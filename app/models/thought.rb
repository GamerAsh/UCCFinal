# == Schema Information
# Schema version: 20110531153223
#
# Table name: thoughts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Thought < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :content, :presence => true, :length => {:maximum => 140}
  validates :user_id, :presence => true

  default_scope :order => 'thoughts.created_at DESC'

  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private
  def self.followed_by(user)
    followed_ids = %(SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id)
    where("user_id IN (#{followed_ids}) OR user_id = :user_id",
          :user_id => user)
  end

end
