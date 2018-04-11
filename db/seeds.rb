# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

seed_script = Rails.root.join( 'db', 'seeds', "#{Rails.env.downcase}.rb")
if seed_script.exist?
  ActiveRecord::Base.transaction { load(seed_script) }
else
  puts 'Seed script file is not exist'
end