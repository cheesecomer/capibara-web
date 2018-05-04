# == Schema Information
#
# Table name: inquiries
#
#  id         :bigint(8)        not null, primary key
#  sender_id  :integer
#  name       :string(255)
#  email      :string(191)      not null
#  content    :text(65535)      not null
#  reply      :text(65535)
#  status     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :inquiry do
    name { Precure.all.sample[:precure_name] }
    email { FFaker::Internet.email }
    content { FFaker::LoremJA.sentence }
  end
end
