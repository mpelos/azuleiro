class Role < EnumerateIt::Base
  associate_values(
    :administrator => 0,
    :user          => 1
  )
end
