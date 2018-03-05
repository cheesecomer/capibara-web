json.set! :blocks do
  json.array! @blocks do |block|
    json.set! :id, block.id
    json.set! :target do
      json.set! :id, block.target.id
      json.set! :nickname, block.target.nickname
    end
  end
end
