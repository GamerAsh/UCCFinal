# == Schema Information
# Schema version: 20110531161221
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  aboutme            :text
#  course             :string(255)
#  faveclasses        :text
#  interests          :text
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :aboutme, :course, :faveclasses, :interests, :password, :password_confirmation

 has_many :relationships, :dependent => :destroy,
                           :foreign_key => "follower_id"
  has_many :reverse_relationships, :dependent => :destroy,
                                   :foreign_key =>"followed_id",
                                   :class_name => "Relationship"
  has_many :following, :through => :relationships, :source => :followed
  has_many :followers, :through => :reverse_relationships,
                       :source  => :follower

  has_many :sent_messages, :class_name => 'Message', :foreign_key =>'sender_id', :order=>'created_at DESC'
  has_many :received_messages, :class_name => 'Message', :foreign_key =>'recipient_id', :order=>'created_at DESC'
  has_many :unread_messages, :class_name => 'Message', :foreign_key =>'recipient_id', :conditions => {:read => false}

  has_many :thoughts, :dependent => :destroy

  has_many :wall_messages, :order => 'created_at DESC'

#  EMAIL_STAFF_REGEX = /\A[\w+\-.]+@mail.blackburn.ac.uk/i
  email_regex = /\A[\w+\-.]+@+(blackburn.ac.uk|mail.blackburn.ac.uk)/i
  
  validates :name,  :presence   => true,
                    :length     => { :maximum => 50}
  validates :aboutme,  :presence   => true,
                    :length     => { :maximum => 300}
  validates :course,  :presence   => true,
                    :length     => { :maximum => 50}
  validates :faveclasses,  :presence   => true,
                    :length     => { :maximum => 300}
  validates :interests,  :presence   => true,
                    :length     => { :maximum => 300}
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false}
                    
  validates :password, :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..40}

  before_save :encrypt_password
  
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def feed
    Thought.from_users_followed_by(self)

  end


  
class << self
  def authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)

  end
    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
 
    

  end
  def following?(followed)
    relationships.find_by_followed_id(followed)

  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
  private
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}") 
  end

  def decrypt()
    
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

end
