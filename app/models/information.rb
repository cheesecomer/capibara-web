# == Schema Information
#
# Table name: information
#
#  id           :bigint(8)        not null, primary key
#  title        :string(255)      not null
#  message      :string(255)      not null
#  published_at :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  content      :text(65535)
#

class Information < ApplicationRecord
  self.table_name = 'information'

  validates :title, presence: true

  validates :message, presence: true

  validates :published_at, presence: true

  scope :published, -> { where(arel_table[:published_at].lteq(Time.zone.now)) }

  def published?
    self.published_at < Time.zone.now
  end
end
