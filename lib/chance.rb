module Chance
  def self.roll(dice_notation)
    repeat = dice_notation.to_s.scan(/^\d+/)[0].to_i
    repeat = 1 if repeat == 0

    sides = dice_notation.to_s.scan(/\d+$/)[0].to_i

    total = 0
    repeat.times do
      # Add the roll to the total
      total += rand(sides) + 1 # Add one because rand returns a range of 0 to n-1
    end
    return (total.is_a? Float) ? nil : total
  end
end
