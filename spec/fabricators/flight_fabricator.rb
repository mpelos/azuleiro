Fabricator :flight do
  origin! { Fabricate :city }
  destination! { Fabricate :city }
  date { Date.current }
end
