# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  nickname                  :string(255)      not null
#  email                     :string(191)
#  encrypted_password        :string(255)
#  reset_password_token      :string(191)
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string(255)
#  last_sign_in_ip           :string(255)
#  access_token              :string(191)
#  biography                 :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  icon                      :string(255)
#  oauth_provider            :integer
#  oauth_access_token        :string(255)
#  oauth_access_token_secret :string(255)
#  oauth_uid                 :string(255)
#
# Indexes
#
#  index_users_on_access_token          (access_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  context '.update_access_token!' do
    subject { user.update_access_token! }
    let(:user) { FactoryGirl.create(:user) }
    it { expect { subject }.to change { user.access_token } }
  end
  describe '#to_broadcast_hash' do
    let(:user) { FactoryGirl.create(:user) }
    subject { user.to_broadcast_hash }
    context 'when valid' do
      it do
        is_expected.to eq(
          {
            id: user.id,
            nickname: user.nickname
          }
        )
      end
    end
  end
end
