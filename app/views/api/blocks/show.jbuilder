json.set! :id, @block.id
json.set! :target do
  json.set! :id, @block.target.id
  json.set! :nickname, @block.target.nickname
end