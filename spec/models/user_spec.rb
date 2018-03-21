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
#  deleted_at                :datetime
#  accepted                  :boolean          default(FALSE), not null
#
# Indexes
#
#  index_users_on_access_token          (access_token) UNIQUE
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  context '.update_access_token!' do
    subject { user.update_access_token! }
    let(:user) { FactoryBot.create(:user) }
    it { expect { subject }.to change { user.access_token } }
  end
  describe '#to_broadcast_hash' do
    let(:user) { FactoryBot.create(:user) }
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
  describe '.find_or_create_from_oauth' do
    subject { User.find_or_create_from_oauth(oauth) }
    let(:oauth) {
      girl = Precure.all.sample
      {
        provider: 'twitter',
        uid: '1',
        info: {
          nickname: girl[:precure_name],
          image: nil,
          description: girl[:transform_message]
        },
        credentials: {
          token: '1234567890',
          secret: 'abcdefghijklmnopqrstuvwxyz'
        }
      }
    }
    context 'when exists' do
      let!(:user) { FactoryBot.create(:user, oauth_provider: :twitter, oauth_uid: 1)}
      it { expect { subject }.to change { User.all.count }.by(0) }
      it { is_expected.to eq(user) }
    end
    context 'when not exists' do
      it { expect { subject }.to change { User.all.count }.by(1) }
    end
  end
end
