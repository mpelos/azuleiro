class Role < EnumerateIt::Base
  associate_values(
    :administrator => 0,
    :traveller     => 1
  )
end
