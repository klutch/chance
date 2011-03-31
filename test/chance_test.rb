require 'test_helper'
require 'ruby-debug'

class ChanceTest < Test::Unit::TestCase
  def confirm_range(range, notation, iterations = 300)
    in_range = true
    iterations.times do
      in_range = ((range) === Chance.roll(notation))
      break unless in_range
    end
    in_range
  end
  
  def confirm_higher_than_lower(high_notation, low_notation, iterations = 300)
    confirm_lower_than_higher(low_notation, high_notation)
  end
  
  def confirm_lower_than_higher(low_notation, high_notation, iterations = 300)
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
    should "on average be lower than the average highest roll" do
      assert_equal true, confirm_lower_than_higher("2d6v", "2d6^")
    end
    
    context "lowest rolls with operations" do
      should "on average be lower than the average highest roll with addition" do
        assert_equal true, confirm_lower_than_higher("5d13v+10", "5d13^+10")
      end

      should "on average be lower than the average highest roll with subtraction" do
        assert_equal true, confirm_lower_than_higher("2d23v-50", "2d23^-50")
      end
    end
  end
  
  context "highest rolls" do
    should "on average be higher than the average lowest roll" do
      assert_equal true, confirm_higher_than_lower("12d60^", "12d60v")
    end
  end
  
  context "maximum rolls" do
    should "be the product of the iterations and number of sides for 4d6H" do
      assert_equal 4 * 6, Chance.roll("4d6H")
    end
    
  end

  context "maximum rolls with operations" do
    should "be correct for 3d18H-10" do
      assert_equal (3*18)-10, Chance.roll("3d18H-10")
    end

    should "be correct for 3d6H+2" do
      assert_equal (3*6)+2, Chance.roll("3d6H+2")
    end

    should "should be greater than the highest possible for 3d3H+^" do
      assert_equal true, Chance.roll("3d3H+^") > 9
    end

    should "should be lower than the lowest possible for 3d3L-v" do
      assert_equal true, Chance.roll("3d3L-v") < 3
    end
  end
  
  context "minimum rolls" do
    should "be the number of iterations 7d20L" do
      assert_equal 7, Chance.roll("7d20L")
    end
  end
  
  context "minimum rolls with operations" do
    should "be the number of iterations 3d28L-50" do
      assert_equal 20, Chance.roll("33d10L-13")
    end
  end
  
  context "rolls with operations" do
    should "be in the 12 to 30 range after multiple rolls for 2d10+10" do
      assert_equal true, confirm_range(12..30, "2d10+10")
    end

    should "be in the -6 to 14 range after multiple rolls for 4d6-10" do
      assert_equal true, confirm_range(-6..14, "4d6-10")
    end

    context "rolls with operations and a low saved roll as the offset" do
      should "be in the 3 to 18 range for 2d6+v" do
        assert_equal true, confirm_range(3..18, "2d6+v", 1000)
      end

      should "be in the 2 to 20 range for 3d10-v" do
        assert_equal true, confirm_range(2..20, "3d10-v", 1000)
      end
      
    end
    
  end
  
end
