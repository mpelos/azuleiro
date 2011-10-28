class Flight < ActiveRecord::Base
  belongs_to              :origin,      :class_name => "City", :foreign_key => "origin_id"
  belongs_to              :destination, :class_name => "City", :foreign_key => "destination_id"
  has_and_belongs_to_many :travels
  has_many                :schedules,   :dependent => :destroy
  has_many                :prices,      :dependent => :destroy

  validates_presence_of :origin, :destination, :date

  default_scope order("origin_id", "destination_id", "date")

  scope :from, lambda { |origin| where(:origin_id => origin.id) }
  scope :to,   lambda { |destination| where(:destination_id => destination.id) }
end
