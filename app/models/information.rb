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
#

class Information < ApplicationRecord
    scope :published, -> { where(arel_table[:published_at].lteq(Time.zone.now)) }
end