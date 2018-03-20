# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  sender_id  :integer          not null
#  target_id  :integer          not null
#  reason     :integer          not null
#  message    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :report do
    
  end
end
