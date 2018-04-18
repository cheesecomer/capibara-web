# == Schema Information
#
# Table name: follows
#
#  id         :integer          not null, primary key
#  owner_id   :integer          not null
#  target_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :follow do
    association :owner, factory: :user
    association :target, factory: :user
  end
end
