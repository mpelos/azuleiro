# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

City.destroy_all

cities = {}
cities["Campinas"]  = "VCP"
cities["Joinville"] = "JOI"
cities["Recife"]    = "REC"

cities.each_pair do |name, code|
  City.create(:name => name, :code => code)
end
