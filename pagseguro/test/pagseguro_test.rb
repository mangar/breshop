require 'test/unit'
require 'yaml'

require File.dirname(__FILE__) + '/../lib/pagseguro'
require File.dirname(__FILE__) + '/../../geral/lib/geral'

class PagseguroTest < Test::Unit::TestCase
  
  def setup
    @item_1 = Item.new({:codigo=>"1",
                        :descricao=>"produto01",
                        :quantidade=>1,
                        :valor=>11.50,
                        :peso=>0.100})

    @item_2 = Item.new({:codigo=>"2",
                        :descricao=>"produto02",
                        :quantidade=>2,
                        :valor=>22.30,
                        :peso=>0.500})

                        
    @config = YAML.load_file(File.dirname(__FILE__) + '/pagseguro_test.yml')
  end
  

  def test_calcular_frete
  
    ps = PsIntegracao.new @config
    
    #testes com PAC.............
    pedido = Pedido.new
    pedido.cep1 = "14055"
    pedido.cep2 = "490"
    pedido.tipo_frete = "EN"
    pedido << @item_1
    
    frete = ps.calcular_frete pedido
    assert_equal("7,20", frete, "Cep: 14055490 / EN / 0.100 ==> 7.20 (1)")
    
    pedido << @item_2
    frete = ps.calcular_frete pedido
    assert_equal("12,61", frete, "Cep: 14055490 / EN / 1.100 ==> 12,61 (2)")
    
    
    #testes com SEDEX............
    pedido = Pedido.new
    pedido.cep1 = "14055"
    pedido.cep2 = "490"
    pedido.tipo_frete = "SD"
    pedido << @item_1
    
    frete = ps.calcular_frete pedido
    assert_equal("10,70", frete, "Cep: 14055490 / SD / 0.100 ==> 10,70 (3)")
    
    pedido << @item_2
    frete = ps.calcular_frete pedido
    assert_equal("13,80", frete, "Cep: 14055490 / SD / 1.100 ==> 13,80 (4)")

  end
  

  def test_to_peso
    pagseguro = PsIntegracao.new
    
    #1.1 - nil
    valor = pagseguro.to_peso nil
    assert_nil valor, "1.1 - nil, se o parametro for nil, o retorno tbem devera ser nil"
    
    #1.2 - valor nao conversivel a decimal
    valor = pagseguro.to_peso "abc"
    assert_equal "000", valor, "1.2 - o valor deve ser conversivel a decimal, caso contrario retornara o peso zerado no formado PS (000)"
  
    #1.3 - valor deve ser uma String
    valor = pagseguro.to_peso 14
    assert_nil nil, "1.3 - valor deve ser uma string"
  
    #2 - entradas validas
    valor = pagseguro.to_peso "0.5"
    assert_equal "500", valor, "2.1 - 0.5 => 500"
  
    valor = pagseguro.to_peso "0.50"
    assert_equal "500", valor, "2.2 - 0.50 => 500"
  
    valor = pagseguro.to_peso "0.500"
    assert_equal "500", valor, "2.3 - 0.500 => 500"
  
    valor = pagseguro.to_peso "0.05"
    assert_equal "050", valor, "2.4 - 0.05 => 050"
  
    valor = pagseguro.to_peso "0.005"
    assert_equal "005", valor, "2.5 - 0.05 => 005"
     
    valor = pagseguro.to_peso "1"
    assert_equal "1000", valor, "2.6 - 1 => 1000"
    
    valor = pagseguro.to_peso "1.0"
    assert_equal "1000", valor, "2.7 - 1.0 => 1000"     
     
    valor = pagseguro.to_peso "1.5"
    assert_equal "1500", valor, "2.8 - 1.5 => 1500"     
     
    valor = pagseguro.to_peso "1.500"
    assert_equal "1500", valor, "2.9 - 1.500 => 1500"
    
    valor = pagseguro.to_peso "1.501"
    assert_equal "1501", valor, "2.10 - 1.501 => 1501"
    
    valor = pagseguro.to_peso "1.510"
    assert_equal "1510", valor, "2.11 - 1.510 => 1510"     
     
  end
  
  def test_to_dinheiro
    pagseguro = PsIntegracao.new

    #1.1 - nil
    valor = pagseguro.to_dinheiro nil
    assert_nil valor, "1.1 - nil, se o parametro for nil, o retorno tbem devera ser nil"
    
    #1.2 - valor nao conversivel a decimal
    valor = pagseguro.to_dinheiro "abc"
    assert_equal "00", valor, "1.2 - o valor deve ser conversivel a decimal, caso contrario retornara o peso zerado no formado PS (000)"
  
    #1.3 - valor deve ser uma String
    valor = pagseguro.to_dinheiro 14
    assert_nil nil, "1.3 - valor deve ser uma string"
        
    #2 - entradas validas 
    valor = pagseguro.to_dinheiro "0.5"
    assert_equal "50", valor, "2.1 - 0.5 => 50 centavos"
    
    valor = pagseguro.to_dinheiro "0.50"
    assert_equal "50", valor, "2.2 - 0.50 => 50 centavos"
    
    valor = pagseguro.to_dinheiro "0.05"
    assert_equal "05", valor, "2.3 - 0.05 => 05 centavos"
    
    valor = pagseguro.to_dinheiro "1"
    assert_equal "100", valor, "2.4 - 1 => 1 real (100)"
    
    valor = pagseguro.to_dinheiro "1.0"
    assert_equal "100", valor, "2.5 - 1.0 => 1 real (100)"
    
    valor = pagseguro.to_dinheiro "1.5"
    assert_equal "150", valor, "2.6 - 1.5 => 1,5 real"
    
    valor = pagseguro.to_dinheiro "1.55"
    assert_equal "155", valor, "2.7 - 1.55 => 1,55 real"
    
    valor = pagseguro.to_dinheiro "1.05"
    assert_equal "105", valor, "2.8 - 1.05 => 105 real (100)"
  end
  
end