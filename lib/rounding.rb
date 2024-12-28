class Numeric
  # round a given number to the nearest step
  def round_by(increment)
    (self / increment).round * increment
  end
end