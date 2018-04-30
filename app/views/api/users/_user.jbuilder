json.extract! user, :id, :nickname, :biography, :icon_url
json.set! :icon_thumb_url, user.icon_url(:thumb)
json.set! :block, Block.where(owner: current_user, target: user).first&.id unless user.id == current_user.id
json.set! :accepted, user.accepted if user.id == current_user.id
json.set! :follow, Follow.where(owner: current_user, target: user).first&.id unless user.id == current_user.id
json.set! :is_follower, Follow.exists?(owner: user, target: current_user) unless user.id == current_user.id