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

require 'rails_helper'

RSpec.describe Information, type: :model do
  describe '#published' do
    subject { Information.published }
    context 'when empty' do
      it { is_expected.to be_empty }
    end
    context 'when future' do
      let!(:information) { FactoryGirl.create(:information, published_at: 1.days.since) }
      it { is_expected.to be_empty }
    end
    context 'when past' do
      let!(:information) { FactoryGirl.create(:information, published_at: 1.days.ago) }
      it { is_expected.to eq [information] }
    end
  end
end
