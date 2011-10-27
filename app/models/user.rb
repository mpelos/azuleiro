class User < ActiveRecord::Base
  include EnumerateIt

  authenticates_with_sorcery!
  has_enumeration_for :role, :create_helpers => true

  has_many :travels, :dependent => :delete_all

  attr_accessible :email, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of     :email, :password, :password_confirmation
  validates_length_of       :password, :minimum => 4
  validates_uniqueness_of   :email

  default_scope order("id desc")
  scope :travellers,     where(:role => Role::TRAVELLER)
  scope :administrators, where(:role => Role::ADMINISTRATOR)

  after_save :send_approval_email, :if => lambda { active_changed? && active? }

  def active?
    active
  end

  def inactive?
    not active?
  end

  def activate!
    update_attribute :active, true
  end

  private

  def send_approval_email
    ApplicationMailer.user_approved(self).deliver
  end
end
