# == Schema Information
# Schema version: 20110531153223
#
# Table name: friendships
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Friendship < ActiveRecord::Base

  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => "friend_id"
  validates_presence_of :user_id, :friend_id

    def self.are_friends(user, friend)
    return false if user == friend
    return true unless find_by_user_id_and_friend_id(user, friend).nil?
    return true unless find_by_user_id_and_friend_id(friend, user).nil?
    false
  end


    def self.request(user, friend)
    return false if are_friends(user, friend)
    return false if user == friend
    f1 = new(:user => user, :friend => friend, :status => "pending")
    f2 = new(:user => friend, :friend => user, :status => "requested")
    transaction do
      f1.save
      f2.save
    end
  end
end
