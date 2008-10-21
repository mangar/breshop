require 'yaml'
require File.dirname(__FILE__) + '/item'
require File.dirname(__FILE__) + '/util'
require File.dirname(__FILE__) + '/sale'

class Pagseguro
  
  attr_accessor :items, :config
  
  def initialize
    @config = YAML.load_file(File.dirname(__FILE__) + "/../config/test.yml")
    @items = Items.new
  end
  
  def <<(item)
    @items << item
  end
  
  def total
    @items.total
  end
  
  def weight
    @items.weight
  end
  
  def sales(destiny, shipping="EN")
    @sales = Sales.new(:items=>@items, :config=>@config, :destiny=>destiny, :shipping=>shipping) 
  end
  
  def shipping(destiny, shipping="EN")
    sales(destiny, shipping)
    @sales.shipping
  end
end
