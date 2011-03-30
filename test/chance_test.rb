require 'test_helper'

class ChanceTest < Test::Unit::TestCase
  context "a roll with an invalid string" do
    should "be nil when given a name" do
      assert_nil Chance.roll("babelfish")
    end
  end
  
  context "a roll of 1d6" do
    setup do
      @roll = Chance.roll "1d6"
    end
    
    should "be in the range of 1 to 6 over 100 rolls" do
      in_range = true
      100.times do
        in_range = ((1..6) === Chance.roll("1d6"))
        break unless in_range
      end
      assert_equal true, in_range
    end
  end
end
