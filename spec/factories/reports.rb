# == Schema Information
#
# Table name: reports
#
#  id         :bigint(8)        not null, primary key
#  sender_id  :integer          not null
#  target_id  :integer          not null
#  reason     :integer          not null
#  message    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :report do
    association :sender, factory: :user
    association :target, factory: :user
    reason { Random.rand(1..5) }
  end
end
