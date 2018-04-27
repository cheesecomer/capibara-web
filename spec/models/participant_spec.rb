# == Schema Information
#
# Table name: participants
#
#  room_id :integer          not null
#  user_id :integer          not null
#

require 'rails_helper'

RSpec.describe Participant, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:room) }
    it { is_expected.to belong_to(:user) }
  end
end
