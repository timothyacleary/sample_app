# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  # let the app CRUD these variables
  attr_accessible :email, :name, :password, :password_confirmation


  # run the BCrypt secure password method
  has_secure_password

    has_many :microposts, dependent: :destroy

  # before the user is saved, do these things
  before_save { |user| user.email.downcase! }
  before_save :create_remember_token

  # send up an error if any of these things come up false
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  			uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true



  # don't let anyone access these methods from outside the app
  private 

  	  # creates a random token to be user for session authentication
	  def create_remember_token
	  	self.remember_token = SecureRandom.urlsafe_base64
	  end

end
