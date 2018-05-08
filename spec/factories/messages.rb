# == Schema Information
#
# Table name: messages
#
#  id         :bigint(8)        not null, primary key
#  content    :text(65535)
#  sender_id  :integer
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string(255)
#

FactoryBot.define do
  factory :message do
    content { FFaker::LoremJA.paragraph }
    association :sender, factory: :user
    association :room, factory: :room
  end
end
