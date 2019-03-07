desc "deploy for ECS"
task :deploy do
  class String
    def to_h
      HashWithIndifferentAccess.new(JSON.load(self))
    end
  end

  current_branch = `git name-rev --name-only HEAD`.chomp
  current_commit = `git rev-parse HEAD`.chomp
  aws = 'aws --output json'

  configs =  HashWithIndifferentAccess.new YAML.load_file(Rails.root.join('config', 'deploy.yml'))
  config = configs[configs.keys.select {|v| current_branch.match(/^#{v}/) }.first]

  if config.blank?
    puts "  Because there is no setting for branch #{current_branch}, we skip the deployment."
    return
  end

  puts 'login ecr'
  system `aws ecr get-login --no-include-email`
  puts
  puts
  updated_repositories = []
  puts '################################################################################'
  puts '#'
  puts "#  Docker Image Build"
  puts '#'
  puts '################################################################################'
  config[:images]
    .each do |v|
      repository_name = v[:repository_uri].split('/').drop(1).join('/')
      puts '================================================================================'
      puts "  NAME   : #{repository_name}"
      puts "  ECR URI: #{v[:repository_uri]}"
      puts '================================================================================'
      puts

      images = `#{aws} ecr list-images --repository-name #{repository_name}`.to_h
      latest_digest = images[:imageIds].select {|v| v[:imageTag] == 'latest' }.first[:imageDigest]
      latest_commit = images[:imageIds].select {|v| v[:imageTag] != 'latest' && v[:imageDigest] == latest_digest }.first[:imageTag]

      puts '  A commit that built latest image'
      puts "    => #{latest_commit}"
      puts '  Current commit'
      puts "    => #{current_commit}"
      puts
      puts

      files = `git diff #{latest_commit}..#{current_commit} --name-only`.lines.map(&:chomp)
      if !v[:dependencies].any? {|f| files.grep(/^#{f}/).present? } && $?.success?
        puts '  The dependent file has not been modified'
        puts '    Dependent Files'
        v[:dependencies].each{|f| puts "      => #{f}"}
        puts
        puts '    Modified Files'
        files&.each{|f| puts "      => #{f}"}
        puts
        puts
        next
      elsif !`git log #{latest_commit}`.tap { break $? }.success?
        puts '  Because could not find the latest commit, will do a force update'
      end

      image_uri  = "#{v[:repository_uri]}:#{current_commit}"

      puts '--------------------------------------------------------------------------------'
      puts '  Build Docker Image'
      puts '--------------------------------------------------------------------------------'
      puts "docker build -t #{image_uri} -f #{v[:docker_file]} #{v[:context]}"
      system "docker build --no-cache=true -t #{image_uri} -f #{v[:docker_file]} #{v[:context]}"
      system "docker tag #{image_uri} #{v[:repository_uri]}:latest"

      puts
      puts
      puts '--------------------------------------------------------------------------------'
      puts '  Build Docker Image'
      puts '--------------------------------------------------------------------------------'
      system "docker push #{image_uri}"
      system "docker push #{v[:repository_uri]}:latest"
      puts
      puts

      updated_repositories << v[:repository_uri]
    end

  tasks_did_not_update = []
  tasks_did_update = {}
  puts '################################################################################'
  puts '#'
  puts "#  Updaet Service"
  puts '#'
  puts '################################################################################'
  config[:services].each do |v|
    puts
    puts '================================================================================'
    puts "  NAME : #{v[:service]}"
    puts '================================================================================'
    current_task_arn = `#{aws} ecs describe-services --services #{v[:service]} --cluster #{v[:cluster]}`.to_h[:services].first[:taskDefinition]
    current_task = `#{aws} ecs describe-task-definition --task-def #{current_task_arn}`.to_h[:taskDefinition]
    task_definition = current_task.slice(:family, :taskRoleArn, :executionRoleArn, :networkMode, :containerDefinitions, :volumes, :placementConstraints, :requiresCompatibilities, :cpu, :memory)
    task_family = task_definition[:family]
    if tasks_did_not_update.include? task_family
      puts "  Docker image update not detected yet"
      puts "  Does update service and task"
      next
    elsif tasks_did_update.has_key?(task_family)
      puts "  Task already update"
    else
      old_images = task_definition[:containerDefinitions].map { |x| x[:image] }
      updated_repositories.each do |repo|
        task_definition[:containerDefinitions]
          .select { |x| x[:image].start_with?(repo) }
          .each { |c| c.tap { |x| x[:image] = "#{repo}:#{current_commit}" } }
      end
      new_images = task_definition[:containerDefinitions].map { |x| x[:image] }
      if new_images == old_images
        puts "  Docker image update not detected yet"
        puts "  Does update service and task"
        tasks_did_not_update << task_family
        next
      else
        puts
        puts '--------------------------------------------------------------------------------'
        puts "  Updaet Task #{task_family}"
        puts '--------------------------------------------------------------------------------'
        puts
        puts "  Update Docker image"
        Hash[*([old_images, new_images].transpose).flatten].each do |o, n|
          next if o == n
          repo = updated_repositories.select {|x| n.start_with?(x) }.first
          name = task_definition[:containerDefinitions].select {|x| x[:image] == n }.first[:name]
          puts "    Container Name: #{name}"
          puts "      #{repo}"
          puts "        from: #{o.gsub(/^#{repo}/, "").gsub(/^:/, "").presence || '(no tag)'}"
          puts "        to  : #{n.gsub(/^#{repo}/, "").gsub(/^:/, "").presence || '(no tag)'}"
        end

        new_task_arn = `#{aws} ecs register-task-definition --cli-input-json "#{task_definition.to_json.gsub(/\"/, "\\\"")}"`.to_h[:taskDefinition]
        tasks_did_update[task_family] = new_task_arn
      end
    end

    new_task = tasks_did_update[task_family]
    puts
    puts "----------------------------------------------------------------"
    puts "  Updaet Service #{v[:service]}"
    puts "----------------------------------------------------------------"
    puts
    puts "  Old task #{task_family}:#{current_task[:revision]}"
    puts "      => #{current_task[:taskDefinitionArn]}"
    puts "  New task #{task_family}:#{new_task[:revision]}"
    puts "      => #{new_task[:taskDefinitionArn]}"
    `#{aws} ecs update-service --cluster #{v[:cluster]} --service #{v[:service]} --task-definition #{new_task[:taskDefinitionArn]}`
  end
end
