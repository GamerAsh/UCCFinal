# == Schema Information
# Schema version: 20110531153223
#
# Table name: messages
#
#  id           :integer         not null, primary key
#  subject      :string(255)
#  body         :text
#  sender_id    :integer
#  recipient_id :integer
#  read         :boolean
#  created_at   :datetime
#  updated_at   :datetime
#

class Message < ActiveRecord::Base

  belongs_to :sender, :class_name => 'User', :foreign_key =>'sender_id'
  belongs_to :recipient, :class_name => 'User', :foreign_key =>'recipient_id'

end
