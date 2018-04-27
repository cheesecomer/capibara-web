# == Schema Information
#
# Table name: participants
#
#  id      :integer          not null, primary key
#  room_id :integer          not null
#  user_id :integer          not null
#

FactoryBot.define do
  factory :participant do
    association :user, factory: :user
  end
end
