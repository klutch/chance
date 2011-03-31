module Chance
  def self.roll(syntax)

    # This regex matches all dice notations listed in the D&D PHB (3.5E).
    #  The regex also allows for saving of the highest or lowest roll.
    if match_data = syntax.match(/\A(\d*)d(\d+)(?:([v^HL]))?(?:([+\/*-])+(\d+|v|\^))?\z/)
      match_data = match_data.to_a
    
      # Remove the first match which is just the syntax string itself
      match_data.shift

      # Build the roll hash
      save_lowest_roll = false
      save_highest_roll = false
      lowest_possible = nil
      highest_possible = nil
      args = %W(iterations sides save_roll operator offset)
      roll_hash = Hash[args.zip(match_data)]
    
      roll_hash.each do |key, value|
        if key == 'iterations'
          roll_hash[key] = roll_hash[key].empty? ? 1 : roll_hash[key].to_i
        elsif key == 'sides'
          roll_hash[key] = roll_hash[key].to_i
        elsif key == 'save_roll'
          save_lowest_roll = (roll_hash[key] == "v") ? true : false
          save_highest_roll = (roll_hash[key] == "^") ? true : false
          if roll_hash[key] =~ /L|H/
            lowest_possible = roll_hash['iterations'].to_i if roll_hash[key] == 'L'
            highest_possible = roll_hash['iterations'].to_i * roll_hash['sides'].to_i if roll_hash[key] == 'H'
            return lowest_possible if roll_hash['operator'].nil? && roll_hash[key] == 'L'
            return highest_possible if roll_hash['operator'].nil? && roll_hash[key] == 'H'
          end
        end
      end
    
      # Calculate first term (roll total, or saved roll)
      first_total = 0
      lowest_roll = nil
      highest_roll = nil
      roll_hash['iterations'].times do
        roll = rand(roll_hash['sides']) + 1
        first_total += roll

        lowest_roll = roll if (lowest_roll.nil? || (lowest_roll && lowest_roll > roll))
        highest_roll = roll if (highest_roll.nil? || (highest_roll && highest_roll < roll))
      end

      # Adjust the total of the first term if needed
      first_total = lowest_roll if save_lowest_roll      
      first_total = highest_roll if save_highest_roll
      first_total = lowest_possible if lowest_possible
      first_total = highest_possible if highest_possible
    
      # Set offset before calculating the next term
      offset_value = 0
      if roll_hash['offset']
        if roll_hash['offset'] == '^'
          offset_value = highest_roll
        elsif roll_hash['offset'] == 'v'
          offset_value = lowest_roll
        else
          offset_value = roll_hash['offset'].to_i
        end
      end
      
      # Calculate second term
      second_total = case roll_hash['operator']
        when '+' then first_total + offset_value
        when '-' then first_total - offset_value
        else first_total
      end

      return second_total
    end
  end
end
