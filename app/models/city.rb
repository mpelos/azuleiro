class City < ActiveRecord::Base
  validates_presence_of :name, :code

  default_scope order("name")

  def to_s
    name
  end
end
