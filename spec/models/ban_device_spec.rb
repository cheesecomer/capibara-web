# == Schema Information
#
# Table name: ban_devices
#
#  id         :integer          not null, primary key
#  device_id  :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe BanDevice, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
