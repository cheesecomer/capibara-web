# == Schema Information
#
# Table name: ban_devices
#
#  id         :bigint(8)        not null, primary key
#  device_id  :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BanDevice < ApplicationRecord
end
