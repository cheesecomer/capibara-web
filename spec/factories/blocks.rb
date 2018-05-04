# == Schema Information
#
# Table name: blocks
#
#  id         :bigint(8)        not null, primary key
#  owner_id   :integer          not null
#  target_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :block do
    association :owner, factory: :user
    association :target, factory: :user
  end
end
