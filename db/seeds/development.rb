puts 'Create users'
odd_user = FactoryBot.create :user, email: 'user1@email.com', password: 'password'
evn_user = FactoryBot.create :user, email: 'user2@email.com', password: 'password'
deleted_user = FactoryBot.create :user, email: 'user3@email.com', password: 'password'
deleted_user.destroy

puts 'Create rooms'
FactoryBot.create_list :room, 10

Room.all.each do |room|
  puts "Create room\##{room.id} messages"
  (1..10).each do
    FactoryBot.create :message, room: room, sender: odd_user
    FactoryBot.create :message, room: room, sender: evn_user
  end
  FactoryBot.create :message, room: room, sender: deleted_user
end

puts 'Create information'
FactoryBot.create_list :information, 10