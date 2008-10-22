require 'test/unit'
require File.dirname(__FILE__) + '/../lib/item'

class ItemTest < Test::Unit::TestCase
  
  def setup
    @item_1 = Item.new({:id=>1, 
                        :descr=>"Primeiro Item", 
                        :valor=>10.0, 
                        :quant=>2, 
                        :peso=>10})
  end
  
  def test_getting_weight_total    
    assert_equal(20, @item_1.weight)
  end
end
