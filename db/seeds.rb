# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


cities = {}
cities["Brasília"]      = "BSB"
cities["Campinas"]      = "VCP"
cities["Florianópolis"] = "FLN"
cities["Joinville"]     = "JOI"
cities["Recife"]        = "REC"

cities.each_pair do |name, code|
  City.find_or_create_by_name_and_code(name, code)
end
