# == Schema Information
#
# Table name: direct_messages
#
#  id           :bigint(8)        not null, primary key
#  addressee_id :integer          not null
#  sender_id    :integer          not null
#  content      :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :direct_message do
    association :addressee, factory: :user
    association :sender, factory: :user
    content { FFaker::LoremJA.paragraph }
  end
end
