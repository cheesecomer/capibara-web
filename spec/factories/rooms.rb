# == Schema Information
#
# Table name: rooms
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  capacity   :integer          not null
#  priority   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

FactoryBot.define do
  titles = Precure.map(&:title).shuffle
  factory :room do
    name do
      titles = Precure.map(&:title).shuffle if titles.empty?
      titles.shift
    end
    capacity 10
    priority 1
  end
end
