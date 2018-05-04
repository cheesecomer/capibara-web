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

require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }
  end
  describe '#capacity' do
    it { is_expected.to validate_presence_of(:capacity) }
    it { is_expected.to validate_numericality_of(:capacity).only_integer.is_greater_than(0) }
  end
  describe '#priority' do
    it { is_expected.to validate_presence_of(:priority) }
    it { is_expected.to validate_numericality_of(:priority).only_integer.is_greater_than(0) }
  end
end
