class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of     :email
  validates_presence_of     :password, :password_confirmation, :on => :create
  validates_length_of       :password, :minimum => 4
  validates_uniqueness_of   :email
end
