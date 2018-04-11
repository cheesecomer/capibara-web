# == Schema Information
#
# Table name: information
#
#  id           :integer          not null, primary key
#  title        :string(255)      not null
#  message      :string(255)      not null
#  published_at :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  content      :text(65535)
#

FactoryBot.define do
  factory :information do
    title { FFaker::LoremJA.sentence }
    message { FFaker::LoremJA.paragraph }
    published_at 1.days.ago
  end
end
