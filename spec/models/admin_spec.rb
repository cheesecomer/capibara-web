# == Schema Information
#
# Table name: admins
#
#  id                     :bigint(8)        not null, primary key
#  nickname               :string(255)      not null
#  email                  :string(191)
#  encrypted_password     :string(255)
#  reset_password_token   :string(191)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe Admin, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
