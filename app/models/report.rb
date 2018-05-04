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

class Report < ApplicationRecord
  # --------------------------------------------------------------------------
  # Associations
  # --------------------------------------------------------------------------
  belongs_to :sender, class_name: 'User'
  belongs_to :target, class_name: 'User'

  enum reason: {
    other: 0,
    spam: 1,
    abusive_or_hateful_speech: 2,
    abusive_or_hateful_image: 3,
    obscene_speech: 4,
    obscene_image: 5,
  }

  # --------------------------------------------------------------------------
  # Validations
  # --------------------------------------------------------------------------
  validates :message, presence: true, if: :other?
end
