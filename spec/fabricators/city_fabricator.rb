Fabricator :city do
  name { Fabricate.sequence(:name) { |i| "city#{i}" } }
  code { Fabricate.sequence(:code) { |i| "CI#{i}" } }
end
