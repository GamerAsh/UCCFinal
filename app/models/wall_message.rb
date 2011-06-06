# == Schema Information
# Schema version: 20110531161221
#
# Table name: wall_messages
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  sender_id  :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class WallMessage < ActiveRecord::Base

  belongs_to :user
  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'

end
