class City < EnumerateIt::Base
  associate_values(
    :campinas   => "VCP",
    :joinville  => "JOI",
    :recife     => "REC"
  )
end
