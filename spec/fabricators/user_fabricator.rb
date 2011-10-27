Fabricator :user do
  email { Fabricate.sequence(:email) { |i| "happyuser#{i}@example.com" } }
  password              "lolwutwtf"
  password_confirmation "lolwutwtf"
end

Fabricator :inactive_user, :from => :user do
  active false
end

Fabricator :active_user, :from => :user do
  active true
end
