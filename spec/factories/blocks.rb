# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  owner_id   :integer          not null
#  target_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :block do
    association :owner, factory: :user
    association :target, factory: :user
  end
end