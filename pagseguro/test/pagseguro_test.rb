require 'test/unit'
require 'yaml'

require File.dirname(__FILE__) + '/../lib/pagseguro'
require File.dirname(__FILE__) + '/../../general/lib/general'

class PagseguroTest < Test::Unit::TestCase
  
  def setup
    @item_1 = Item.new({:code=>"1",
                        :description=>"produto01",
                        :quantity=>1,
                        :price=>11.50,
                        :weight=>0.100})

    @item_2 = Item.new({:code=>"2",
                        :description=>"produto02",
                        :quantity=>2,
                        :price=>22.30,
                        :weight=>0.500})

                        
    @config = YAML.load_file(File.dirname(__FILE__) + '/pagseguro_test.yml')
  end
  

  def test_shipment_price
  
    ps = Integration.new @config
    
    #testes com PAC.............
    sale = Sale.new
    sale.zip1 = "14055"
    sale.zip2 = "490"
    sale.shipment_type = "EN"
    sale << @item_1
    
    shipment = ps.shipment_price sale
    assert_equal("7,20", shipment, "Cep: 14055490 / EN / 0.100 ==> 7.20 (1)")
    
    sale << @item_2
    shipment = ps.shipment_price sale
    assert_equal("12,61", shipment, "Cep: 14055490 / EN / 1.100 ==> 12,61 (2)")
    
    
    #testes com SEDEX............
    sale = Sale.new
    sale.zip1 = "14055"
    sale.zip2 = "490"
    sale.shipment_type = "SD"
    sale << @item_1
    
    shipment = ps.shipment_price sale
    assert_equal("10,70", shipment, "Cep: 14055490 / SD / 0.100 ==> 10,70 (3)")
    
    sale << @item_2
    shipment = ps.shipment_price sale
    assert_equal("13,80", shipment, "Cep: 14055490 / SD / 1.100 ==> 13,80 (4)")

  end
  

  def test_to_weight
    pagseguro = Integration.new
    
    #1.1 - nil
    price = pagseguro.to_weight nil
    assert_nil price, "1.1 - nil, se o parametro for nil, o retorno tbem devera ser nil"
    
    #1.2 - price nao conversivel a decimal
    price = pagseguro.to_weight "abc"
    assert_equal "000", price, "1.2 - o price deve ser conversivel a decimal, caso contrario retornara o weight zerado no formado PS (000)"
  
    #1.3 - price deve ser uma String
    price = pagseguro.to_weight 14
    assert_nil nil, "1.3 - price deve ser uma string"
  
    #2 - entradas validas
    price = pagseguro.to_weight "0.5"
    assert_equal "500", price, "2.1 - 0.5 => 500"
  
    price = pagseguro.to_weight "0.50"
    assert_equal "500", price, "2.2 - 0.50 => 500"
  
    price = pagseguro.to_weight "0.500"
    assert_equal "500", price, "2.3 - 0.500 => 500"
  
    price = pagseguro.to_weight "0.05"
    assert_equal "050", price, "2.4 - 0.05 => 050"
  
    price = pagseguro.to_weight "0.005"
    assert_equal "005", price, "2.5 - 0.05 => 005"
     
    price = pagseguro.to_weight "1"
    assert_equal "1000", price, "2.6 - 1 => 1000"
    
    price = pagseguro.to_weight "1.0"
    assert_equal "1000", price, "2.7 - 1.0 => 1000"     
     
    price = pagseguro.to_weight "1.5"
    assert_equal "1500", price, "2.8 - 1.5 => 1500"     
     
    price = pagseguro.to_weight "1.500"
    assert_equal "1500", price, "2.9 - 1.500 => 1500"
    
    price = pagseguro.to_weight "1.501"
    assert_equal "1501", price, "2.10 - 1.501 => 1501"
    
    price = pagseguro.to_weight "1.510"
    assert_equal "1510", price, "2.11 - 1.510 => 1510"     
     
  end
  
  def test_to_money
    pagseguro = Integration.new

    #1.1 - nil
    price = pagseguro.to_money nil
    assert_nil price, "1.1 - nil, se o parametro for nil, o retorno tbem devera ser nil"
    
    #1.2 - price nao conversivel a decimal
    price = pagseguro.to_money "abc"
    assert_equal "00", price, "1.2 - o price deve ser conversivel a decimal, caso contrario retornara o weight zerado no formado PS (000)"
  
    #1.3 - price deve ser uma String
    price = pagseguro.to_money 14
    assert_nil nil, "1.3 - price deve ser uma string"
        
    #2 - entradas validas 
    price = pagseguro.to_money "0.5"
    assert_equal "50", price, "2.1 - 0.5 => 50 centavos"
    
    price = pagseguro.to_money "0.50"
    assert_equal "50", price, "2.2 - 0.50 => 50 centavos"
    
    price = pagseguro.to_money "0.05"
    assert_equal "05", price, "2.3 - 0.05 => 05 centavos"
    
    price = pagseguro.to_money "1"
    assert_equal "100", price, "2.4 - 1 => 1 real (100)"
    
    price = pagseguro.to_money "1.0"
    assert_equal "100", price, "2.5 - 1.0 => 1 real (100)"
    
    price = pagseguro.to_money "1.5"
    assert_equal "150", price, "2.6 - 1.5 => 1,5 real"
    
    price = pagseguro.to_money "1.55"
    assert_equal "155", price, "2.7 - 1.55 => 1,55 real"
    
    price = pagseguro.to_money "1.05"
    assert_equal "105", price, "2.8 - 1.05 => 105 real (100)"
  end
  
end