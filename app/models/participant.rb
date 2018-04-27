# == Schema Information
#
# Table name: participants
#
#  room_id :integer          not null
#  user_id :integer          not null
#

class Participant < ApplicationRecord
  belongs_to :room
  belongs_to :user
end
