require 'rubygems'
require 'uri'
require 'net/http'
require 'net/https'
require 'hpricot'
require "erb"

class Integration
    
  #TODO test
  def initialize(pars = {})
    
    @config = (pars[:config].nil? ? YAML.load_file(File.dirname(__FILE__) + "/../config/pagseguro.yml") : pars[:config])

    @parametros_config = "tipo=#{@config['tipo_carrinho']}"
    @parametros_config << "&moeda=#{@config['moeda']}"
    @parametros_config << "&email_cobranca=#{@config['email_cobranca']}"
    
    @uri = URI.parse(@config['webpagto'])
  end


  # Calcula o preco do frete baseado nas informacoes:
  # peso: peso total do sale
  # tipo_frete: tipo de frete escolhido EN(PAC) ou SD(Sedex)
  # cep: cep de destino da mercadoria
  # email_loja: email cadastrado no PagSeguro, o cep de origem está localizado no cadastro do vendedor
  #
  # Ex.:
  # PsIntegracao.calcula_frete sale ==> 12.95
  #
  #TODO Test
  def shipment_price(sale)
        
    parametros = []
    parametros << "&tipo_frete=#{sale.shipment_type}"    
    parametros << "&cliente_cep=#{sale.zip1}#{sale.zip2}" 

    sale.itens.values.each_with_index do |item, i| 
      parametros << "&item_id_#{i+1}=#{item.code}"
      parametros << "&item_descr_#{i+1}=#{ERB::Util.url_encode(item.description)}"
      parametros << "&item_quant_#{i+1}=#{item.quantity}"
      parametros << "&item_valor_#{i+1}=#{to_money(item.price_total.to_s)}"
      parametros << "&item_peso_#{i+1}=#{to_weight(item.weight_total.to_s)}"
    end
    
    http = Net::HTTP.new(@uri.host, 443)
    http.use_ssl = true
    
    # puts "#{@uri.host}#{@uri.path}?#{@parametros_config}#{parametros}"
    resp, html = http.get("#{@uri.path}?#{@parametros_config}#{parametros}", nil)
    
    @source = Hpricot(html)
    # puts "\n\n\n #{@source} \n\n\n"
    
    price = (@source/"#lblValorFrete").first.inner_html
    price = price.sub(',','.').to_f
  end





  # Cria o formulario no formato HTML para o post que será enviado ao site do PagSeguro
  # 
  # Ex.:
  # @form_html = PsIntegracao.criar_htmlform(ps_cliente, ps_items)
  #
  #TODO test
  #TODO colocar em um helper (??)
  def self.checkout_htmlform id_transacao, ps_cliente, ps_items, *frete

    raise "Cliente inválido!" if (ps_cliente.nil?)
    raise "Os Itens do carrinho de compras, devem ser um Array de PsItem." if (ps_items.class != Array)    
    raise "É necessário que o carrinho tenha pelo menos um item." if (ps_items.nil? || ps_items.size == 0)
  
    # checagem do cep...
    data =  "<form action=\"#{WEBPAGTO}\" method=\"post\" name=\"payment_form\"> \n"
    data += " <input type=\"hidden\" name=\"ref_transacao\" value=\"#{id_transacao}\" /> \n"
    data += " <input type=\"hidden\" name=\"email_cobranca\" value=\"#{EMAIL_COBRANCA}\" /> \n"
    data += " <input type=\"hidden\" name=\"tipo\" value=\"#{TIPO_CARRINHO}\" /> \n"
    data += " <input type=\"hidden\" name=\"moeda\" value=\"#{MOEDA}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_pais\" value=\"#{PAIS}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_nome\" value=\"#{ps_cliente.cliente_nome}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_cep\" value=\"#{ps_cliente.cliente_cep}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_end\" value=\"#{ps_cliente.cliente_end}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_num\" value=\"#{ps_cliente.cliente_num}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_compl\" value=\"#{ps_cliente.cliente_compl}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_bairro\" value=\"#{ps_cliente.cliente_bairro}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_cidade\" value=\"#{ps_cliente.cliente_cidade}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_uf\" value=\"#{ps_cliente.cliente_uf}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_ddd\" value=\"#{ps_cliente.cliente_ddd}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_tel\" value=\"#{ps_cliente.cliente_tel}\" /> \n"
    data += " <input type=\"hidden\" name=\"cliente_email\" value=\"#{ps_cliente.cliente_email}\" /> \n"

    #id do sale....
    
    #tipo de frete..
    if (!frete.empty?)
      
      #frete por peso (https://pagseguro.uol.com.br/Security/WebPagamentos/ConfigWebPagto.aspx)
      if ((frete.member? "EN") || (frete.member? "SD"))
        data += " <input type=\"hidden\" name=\"tipo_frete\" value=\"#{frete.first}\" /> \n"
        
      #frete fixo (https://pagseguro.uol.com.br/Security/WebPagamentos/ConfigWebPagto.aspx)
      else
        data += " <input type=\"hidden\" name=\"item_frete_1\" value=\"#{frete.first}\" /> \n"      
      end
    end
    
    i = 1
    ps_items.each do |item|
      data += " <input type=\"hidden\" name=\"item_id_#{i}\" value=\"#{item.id}\" /> \n"
      data += " <input type=\"hidden\" name=\"item_descr_#{i}\" value=\"#{item.descricao}\" /> \n"
      data += " <input type=\"hidden\" name=\"item_quant_#{i}\" value=\"#{item.quantidade}\" /> \n"
      data += " <input type=\"hidden\" name=\"item_valor_#{i}\" value=\"#{item.valor}\" /> \n"
      data += " <input type=\"hidden\" name=\"item_peso_#{i}\" value=\"#{item.peso}\" /> \n"      

      #TODO colocar o valor do frete.....
      i += 1
    end
    
    data += "<input type=\"submit\" />"
    # data += "<script language=\"JavaScript\"> document.payment_form.submit(); </script>"
    data += "</form>"
    
  end



  # Formata o campo de decimal para String no padrao solicitado do PagSeguro
  # Ex.:
  # integracao.to_peso "0.5" ==> 500      #500 gramas
  # integracao.to_peso "0.50 ==> 500     #500 gramas
  # integracao.to_peso "0.05" ==> 050     #50 gramas
  # integracao.to_peso "0.005" ==> 005    #5 gramas
  # integracao.to_peso "1" ==> 1000       #1 kilo
  # integracao.to_peso "1.0" ==> 1000     #1 kilo
  #
  def to_weight valor    
    return nil if valor.nil?
    return nil if valor.class != String
    return "000" if valor.to_f == 0

    # obtem a parte fracionaria e transforma em string.
    frac = valor.to_f - valor.to_i
    frac = frac.to_s + "00"         
    frac = frac[2..4]
    inteiro = ""
    inteiro = valor.to_i.to_s if (valor.to_f.truncate > 0)
    novo_valor = inteiro + frac.to_s    
  end


  # Formata o campo de decimal para String no padrao solicitado do PagSeguro
  # Ex.:
  # integracao.to_dinheiro "0.5" ==> 50      #50 centavos
  # integracao.to_dinheiro "0.50 ==> 50      #50 centavos
  # integracao.to_dinheiro "0.05" ==> 05     #5 centavos
  # integracao.to_dinheiro "1" ==> 100       #1 real
  # integracao.to_dinheiro "1.0" ==> 100     #1 real
  #
  def to_money valor
     return nil if valor.nil?
     return nil if valor.class != String
     return "00" if valor.to_f == 0

     # obtem a parte fracionaria e transforma em string.
     frac = valor.to_f - valor.to_i
     frac = frac.to_s + "0"         
     frac = frac[2..3]
     # Se tiver parte inteira, concatena com a parte fracionaria
     inteiro = ""
     inteiro = valor.to_i.to_s if valor.to_f.truncate > 0
     inteiro + frac
  end


  # # Envia um post para o PagSeguro solicitando a autenticidade do post enviado pelo PagSeguro
  # # Segundo a documentacao do PagSeguro, após o pagamento da compra, o sistema envia uma notificacao
  # # via post para o site do lojista.
  # # Este metodo é o responsavel por processar este post e conferir se os dados gravados na base de dados
  # # local está igual ao enviado pelo PagSeguro
  # # Caso tenha algo diferente retorna o Hash com a diferenca
  # #
  # # Ex.:
  # # PsIntegracao.compara_post_notificacao request, cliente, items ==> ['Nome' => 'valor_antigo > novo_valor']
  # def self.compara_post_notification request, ps_cliente, ps_items
  #   #TODO
  #   #TODO TEST
  # end
  # 
  # 
  # # Envia um post para o PagSeguro solicitando a autenticidade do post enviado pelo PagSeguro
  # # Segundo a documentacao do PagSeguro, após o pagamento da compra, o sistema envia uma notificacao
  # # via post para o site do lojista.
  # # Este metodo é o responsavel por enviar um novo post ao PS, solicitando a autenticidade do post recebido 
  # # informando o processamento da trasnacao, geramente a confirmacao de pagamento.
  # #
  # # Ex.:
  # # PsIntegracao.confirma_autenticidade cliente, items ==> ['FRAUDE', 'Alteracao do status da transacao fraudulenta!']
  # # PsIntegracao.confirma_autenticidade cliente, items ==> ['OK', 'Alteracao do status da transacao verificada!']  
  # #
  # def self.confirma_autenticidade ps_cliente, ps_items
  #   #TODO
  #   #TODO TEST
  # end



end