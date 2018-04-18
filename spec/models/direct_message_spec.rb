# == Schema Information
#
# Table name: direct_messages
#
#  id           :integer          not null, primary key
#  addressee_id :integer          not null
#  sender_id    :integer          not null
#  content      :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe DirectMessage, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:addressee) }
    it { is_expected.to belong_to(:sender) }
  end
end
