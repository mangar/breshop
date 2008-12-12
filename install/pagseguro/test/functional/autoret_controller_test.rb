require File.dirname(__FILE__) + '/../test_helper'
require 'autoret_controller'

class AutoretController; def rescue_action(e)raise e end; end

class AutoretControllerTest < ActionController::TestCase
  
  def setup
    @controller = AutoretController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_post_notification_one_product
    
    # cleanning db..
    Pstransaction.delete_all
    Psproduct.delete_all
    
    txs = Pstransaction.find(:all)
    assert_equal 0, txs.size, "DB must be clean (Pstransaction)"

    prods = Psproduct.find(:all)
    assert_equal 0, prods.size, "DB must be clean (Psproduct)"
    
    # http://localhost:3000/autoret?VendedorEmail=emaildovendedor&TransacaoID=123&Referencia=referencia&TipoFrete=FR&ValorFrete=10,00&Anotacao=anotacaooo&DataTransacao=dd/mm/yyyy hh:mm:ss&TipoPagamento=Pagamento via cartão de crédito&StatusTransacao=Em Análise&CliNome=NomeDoCabra&CliEmail=email@uol.com.br&CliEndereco=Endereco do cliente&CliNumero=1741&CliComplemento=AP22&CliBairro=Moema&CliCidade=Sao Paulo&CliEstado=SP&CliCEP=14055490&CliTelefone=00 00000000&NumItens=1&ProdID_1=1&ProdDescricao_1=Nome do Produto 01&ProdValor_1=100,00&ProdQuantidade_1=2&ProdFrete_1=10&ProdExtras_1=0    
    post :index, :VendedorEmail  => 'emaildovendedor', 
                :TransacaoID => '123' , 
                :Referencia => 'referencia' , 
                :TipoFrete => 'FR' , 
                :ValorFrete => '10,00' , 
                :Anotacao => 'anotacaooo' , 
                :DataTransacao => 'dd/mm/yyyy hh :mm:ss' , 
                :TipoPagamento => 'Pagamento via cartão de crédito' , 
                :StatusTransacao => 'Em Análise' , 
                :CliNome => 'NomeDoCabra' , 
                :CliEmail => 'email@uol.com.br' , 
                :CliEndereco => 'Endereco do cliente' , 
                :CliNumero => '1741' , 
                :CliComplemento => 'AP22' , 
                :CliBairro => 'Moema' , 
                :CliCidade => 'Sao Paulo' ,
                :CliEstado => 'SP' , 
                :CliCEP => '14055490' , 
                :CliTelefone => '00 00000000' , 
                :NumItens => '1' , 
                :ProdID_1 => '1' , 
                :ProdDescricao_1 => 'Nome do Produto 01' , 
                :ProdValor_1 => '100,00' , 
                :ProdQuantidade_1 => '2' , 
                :ProdFrete_1 => '10', 
                :ProdExtras_1 => '0'        
    
    txs = Pstransaction.find(:all)
    assert_equal 1, txs.size, "DB must be clean (Pstransaction)"

    prods = Psproduct.find(:all)
    assert_equal 1, prods.size, "DB must be clean (Psproduct)"

  end
  
  def test_post_notification_two_products
    
    # cleanning db..
    Pstransaction.delete_all
    Psproduct.delete_all
    
    txs = Pstransaction.find(:all)
    assert_equal 0, txs.size, "DB must be clean (Pstransaction)"

    prods = Psproduct.find(:all)
    assert_equal 0, prods.size, "DB must be clean (Psproduct)"
    
    # http://localhost:3000/autoret?VendedorEmail=emaildovendedor&TransacaoID=123&Referencia=referencia&TipoFrete=FR&ValorFrete=10,00&Anotacao=anotacaooo&DataTransacao=dd/mm/yyyy hh:mm:ss&TipoPagamento=Pagamento via cartão de crédito&StatusTransacao=Em Análise&CliNome=NomeDoCabra&CliEmail=email@uol.com.br&CliEndereco=Endereco do cliente&CliNumero=1741&CliComplemento=AP22&CliBairro=Moema&CliCidade=Sao Paulo&CliEstado=SP&CliCEP=14055490&CliTelefone=00 00000000&NumItens=2&ProdID_1=1&ProdDescricao_1=Nome do Produto 01&ProdValor_1=100,00&ProdQuantidade_1=2&ProdFrete_1=10&ProdExtras_1=0&&ProdID_2=2&ProdDescricao_2=Nome do Produto 02&ProdValor_2=200,00&ProdQuantidade_2=22&ProdFrete_2=20&ProdExtras_2=0    
    post :index, :VendedorEmail  => 'emaildovendedor', 
                :TransacaoID => '123' , 
                :Referencia => 'referencia' , 
                :TipoFrete => 'FR' , 
                :ValorFrete => '10,00' , 
                :Anotacao => 'anotacaooo' , 
                :DataTransacao => 'dd/mm/yyyy hh :mm:ss' , 
                :TipoPagamento => 'Pagamento via cartão de crédito' , 
                :StatusTransacao => 'Em Análise' , 
                :CliNome => 'NomeDoCabra' , 
                :CliEmail => 'email@uol.com.br' , 
                :CliEndereco => 'Endereco do cliente' , 
                :CliNumero => '1741' , 
                :CliComplemento => 'AP22' , 
                :CliBairro => 'Moema' , 
                :CliCidade => 'Sao Paulo' ,
                :CliEstado => 'SP' , 
                :CliCEP => '14055490' , 
                :CliTelefone => '00 00000000' , 
                :NumItens => '2' , 
                :ProdID_1 => '1' , 
                :ProdDescricao_1 => 'Nome do Produto 01' , 
                :ProdValor_1 => '100,00' , 
                :ProdQuantidade_1 => '2' , 
                :ProdFrete_1 => '10', 
                :ProdExtras_1 => '0',
                :ProdID_2 => '2' , 
                :ProdDescricao_2 => 'Nome do Produto 02' , 
                :ProdValor_2 => '200,00' , 
                :ProdQuantidade_2 => '4' , 
                :ProdFrete_2 => '20', 
                :ProdExtras_2 => '0'        
    
    txs = Pstransaction.find(:all)
    # puts "Transactions count: #{txs.size}"    
    assert_equal 1, txs.size, "DB must be clean (Pstransaction)"

    prods = Psproduct.find(:all)
    # puts "Product count: #{prods.size}"
    assert_equal 2, prods.size, "DB must be clean (Psproduct)"

  end  
  
  def test_post_notification_three_products
    
    # cleanning db..
    Pstransaction.delete_all
    Psproduct.delete_all    
    
    txs = Pstransaction.find(:all)
    assert_equal 0, txs.size, "DB must be clean (Pstransaction)"

    prods = Psproduct.find(:all)
    assert_equal 0, prods.size, "DB must be clean (Psproduct)"

    post :index, :VendedorEmail  => 'emaildovendedor', 
                :TransacaoID => '123' , 
                :Referencia => 'referencia' , 
                :TipoFrete => 'FR' , 
                :ValorFrete => '10,00' , 
                :Anotacao => 'anotacaooo' , 
                :DataTransacao => 'dd/mm/yyyy hh :mm:ss' , 
                :TipoPagamento => 'Pagamento via cartão de crédito' , 
                :StatusTransacao => 'Em Análise' , 
                :CliNome => 'NomeDoCabra' , 
                :CliEmail => 'email@uol.com.br' , 
                :CliEndereco => 'Endereco do cliente' , 
                :CliNumero => '1741' , 
                :CliComplemento => 'AP22' , 
                :CliBairro => 'Moema' , 
                :CliCidade => 'Sao Paulo' ,
                :CliEstado => 'SP' , 
                :CliCEP => '14055490' , 
                :CliTelefone => '00 00000000' , 
                :NumItens => '3' , 
                :ProdID_1 => '1' , 
                :ProdDescricao_1 => 'Nome do Produto 01' , 
                :ProdValor_1 => '100,00' , 
                :ProdQuantidade_1 => '2' , 
                :ProdFrete_1 => '10', 
                :ProdExtras_1 => '0',
                :ProdID_2 => '2' , 
                :ProdDescricao_2 => 'Nome do Produto 02' , 
                :ProdValor_2 => '200,00' , 
                :ProdQuantidade_2 => '4' , 
                :ProdFrete_2 => '20', 
                :ProdExtras_2 => '0',
                :ProdID_3 => '3' , 
                :ProdDescricao_3 => 'Nome do Produto 03' , 
                :ProdValor_3 => '300,00' , 
                :ProdQuantidade_3 => '6' , 
                :ProdFrete_3 => '30', 
                :ProdExtras_3 => '0'    
    
    txs = Pstransaction.find(:all)
    # puts "Transactions count: #{txs.size}"    
    assert_equal 1, txs.size, "DB must be clean (Pstransaction)"

    prods = Psproduct.find(:all)
    # puts "Product count: #{prods.size}"
    assert_equal 3, prods.size, "DB must be clean (Psproduct)"

  end  
  
  def test_clean
    
    txs = Pstransaction.find(:all)
    assert_equal 1, txs.size, "At least one record from Fixtures (Pstransaction)"
  
    prods = Psproduct.find(:all)
    assert_equal 1, prods.size, "At least one record from Fixtures (Psproduct)"    
    
    post :clean
    assert_redirected_to :action => "show"
    
    txs = Pstransaction.find(:all)
    assert_equal 0, txs.size, "DB must be clean (Pstransaction)"
  
    prods = Psproduct.find(:all)
    assert_equal 0, prods.size, "DB must be clean (Psproduct)"
  
  end
  
  def test_show
    
    txs = Pstransaction.find(:all)
    assert_equal 1, txs.size, "At least one record from Fixtures (Pstransaction)"
  
    prods = Psproduct.find(:all)
    assert_equal 1, prods.size, "At least one record from Fixtures (Psproduct)"
    
    post :show
    assert_not_nil assigns(:txs)
    
  end
  
end
