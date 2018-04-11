json.extract! user, :id, :nickname, :biography, :icon_url
json.set! :icon_thumb_url, user.icon_url(:thumb)
json.set! :is_block, Block.exists?(owner: current_user, target: user) unless user.id == current_user.id
json.set! :accepted, user.accepted if user.id == current_user.id