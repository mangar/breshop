require 'test/unit'
require 'yaml'
require File.dirname(__FILE__) + '/../lib/sale'
require File.dirname(__FILE__) + '/../lib/items'

class SalesTest < Test::Unit::TestCase
  def setup
    @items = Items.new
    @item_1 = Item.new({:id=>1,
                        :descr=>"Primeiro Item",
                        :valor=>10.0,
                        :quant=>2,
                        :peso=>10})
    @items << @item_1
    @config = YAML.load_file(File.dirname(__FILE__) + "/../config/test.yml")
  end
  
  def test_getting_shipping_price
    @sales = Sales.new(:items=>@items, :config=>@config, :destiny=>"05116050", :shipping=>"SD")
    assert_equal("9,50", @sales.shipping)
  end
end