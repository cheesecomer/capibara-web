json.set! :id, @user.id
json.set! :nickname, @user.nickname
json.set! :biography, @user.biography
json.set! :icon_url, @user.icon_url
json.set! :is_block, Block.exists?(owner: current_user, target: @user)