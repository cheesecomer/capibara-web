puts 'Create users'
odd_user = FactoryGirl.create :user, email: 'user1@email.com', password: 'password'
evn_user = FactoryGirl.create :user, email: 'user2@email.com', password: 'password'

puts 'Create rooms'
FactoryGirl.create_list :room, 10

Room.all.each do |room|
  puts "Create room\##{room.id} messages"
  (1..10).each do
    FactoryGirl.create :message, room: room, sender: odd_user
    FactoryGirl.create :message, room: room, sender: evn_user
  end
end