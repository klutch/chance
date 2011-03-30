require 'test_helper'
require 'ruby-debug'

class ChanceTest < Test::Unit::TestCase
  def confirm_range(range, notation, iterations = 100)
    in_range = true
    iterations.times do
      in_range = ((range) === Chance.roll(notation))
      break unless in_range
    end
    in_range
  end
  
  def confirm_higher_than_lower(high_notation, low_notation, iterations = 100)
    confirm_lower_than_higher(low_notation, high_notation)
  end
  
  def confirm_lower_than_higher(low_notation, high_notation, iterations = 100)
    low_total = 0
    iterations.times do
      low_total += Chance.roll(low_notation)
    end
    low_average = low_total / iterations
    
    high_total = 0
    iterations.times do
      high_total += Chance.roll(high_notation)
    end
    high_average = high_total / iterations
    
    return (low_average < high_average)
  end

  context "a roll with an invalid strings" do
    should "be nil when given a name" do
      assert_nil Chance.roll("babelfish")
    end
    
    should "be nil when given a malformed notation" do
      assert_nil Chance.roll("2f20")
    end
  end
  
  context "single rolls" do
    should "be in the range of 1 to 6 over 100 rolls for 1d6" do
      assert_equal true, confirm_range(1..6, "1d6")
    end
    
    should "be in the range of 1 to 150 over 100 rolls for 1d150" do
      assert_equal true, confirm_range(1..150, "1d150")
    end
    
    should "be in the range of 1 to 1337 over 100 rolls for 1d1337" do
      assert_equal true, confirm_range(1..1337, "1d1337")
    end    
  end
  
  context "multiple rolls" do
    should "be in the range of 2 to 16 over 100 rolls for 2d8" do
      assert_equal true, confirm_range(2..16, "2d8")
    end

    should "be in the range of 3 to 18 over 100 rolls for 3d6" do
      assert_equal true, confirm_range(3..18, "3d6")
    end
    
    should "be in the range of 40 to 2720 over 100 rolls for 40d68" do
      assert_equal true, confirm_range(40..2720, "40d68")
    end
  end
  
  context "lowest rolls" do
    should "average out over 100 rolls to be lower than the average high roll" do
      assert_equal true, confirm_lower_than_higher("2d6v", "2d6^")
    end
  end
  
  context "highest rolls" do
    should "average out over 100 rolls to be higher than the average low roll" do
      assert_equal true, confirm_higher_than_lower("12d60^", "12d60v")
    end
  end
  
  
end
