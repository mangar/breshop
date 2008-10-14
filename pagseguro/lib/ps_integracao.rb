class PsIntegracao
  
  # Email do vendedor do PagSeguro.
  # Para que a loja comece a receber os pagamento pelo PagSeguro é necessário que o lojista tenha 
  # o cadastro no PagSeguro e que este esteja habilitado a receber / efetuar vendas pelo site.
  #
  # Este valor pode ser definido no environment.rb
  EMAIL_COBRANCA = "email_cadastrado_no_pagseguro@uol.com.br"
  
  # Tipo padrao do carrinho de compras, este campo pode conter dois tipo de valores
  # de acordo com a documentacao do PagSeguro: 
  # CP = Carrinho Proprio, ou seja o cliente será enviado para o site do PagSeguro apenas para o pagamento
  #      todo o controle de inclusao e remocao de itens do carrinho de compras é de responsabilidade da loja
  #
  # Este valor pode ser definido no environment.rb
  TIPO_CARRINHO = "CP"
  
  # Moeda padrao do pagamento, por enquanto o PagSeguro só atende o Brasil/Real
  # Moeda padrao: BRL (Brazilian Real)
  MOEDA = "BRL"
  
  # Pais do cliente, por enquanto o PagSeguro só atende o Brasil
  # Pais padrão: BRA (Brazil)
  PAIS = "BRA"

  # URL do post para o site do PagSeguro
  WEBPAGTO = "https://pagseguro.uol.com.br/security/webpagamentos/webpagto.aspx?"


  # Calcula o preco do frete baseado nas informacoes:
  # peso: peso total do pedido
  # tipo_frete: tipo de frete escolhido EN(PAC) ou SD(Sedex)
  # cep: cep de destino da mercadoria
  # email_loja: email cadastrado no PagSeguro, o cep de origem está localizado no cadastro do vendedor
  #
  # Ex.:
  # PsIntegracao.calcula_frete "1500", "159900", "EN", "04515030", "marcio.mangar@uol.com.br" ==> 12.95
  #
  def self.calcula_frete(peso, valor_total, tipo_frete, cep, email_loja)
#TODO TEST
    http = Net::HTTP.new('pagseguro.uol.com.br', 443)
    http.use_ssl = true
    path = "/security/webpagamentos/webpagto.aspx?moeda=BRL&item_id_1=1&item_descr_1=CalculoDeFrete&item_quant_1=1&item_valor_1=#{valor_total}&tipo=CP&email_cobranca=#{email_loja}&item_peso_1=#{peso}&tipo_frete=#{tipo_frete}&cliente_cep=#{cep}"

    # puts "\n\n\n\n URL: https://pagseguro.uol.com.br#{path} \n\n\n\n"

    #envia o request para o servidor....
    data = http.get(path, nil).body

    #tratamento da string...
    data = data.slice(data.index("<span id=\"lblValorFrete\" class=\"TextoP\">")..data.size)
    data = data.slice(0..data.index("</span>")-1)
    data = data.slice(data.index(">")+1..data.size)
    data = data.gsub(',','.')
    
    data.to_d
  end


  # Cria o formulario no formato HTML para o post que será enviado ao site do PagSeguro
  # 
  # Ex.:
  # @form_html = PsIntegracao.criar_htmlform(ps_cliente, ps_items)
  #
  def self.checkout_htmlform id_transacao, ps_cliente, ps_items, *frete
# TODO TEST

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

    #id do pedido....
    
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
  # PsIntegracao.to_peso "0.5" ==> 500      #500 gramas
  # PsIntegracao.to_peso "0.50 ==> 500     #500 gramas
  # PsIntegracao.to_peso "0.05" ==> 050     #50 gramas
  # PsIntegracao.to_peso "0.005" ==> 005    #5 gramas
  # PsIntegracao.to_peso "1" ==> 1000       #1 kilo
  # PsIntegracao.to_peso "1.0" ==> 1000     #1 kilo
  #
  def self.to_peso valor
    return nil if valor.nil?
    return nil if valor.class != String

    frac = valor.to_d.frac.to_s + "00"
    frac = frac[2,3]
    inteiro = ""
    inteiro = valor.to_i.to_s if (valor.to_i > 0)
    novo_valor = inteiro + frac.to_s
  end


  # Formata o campo de decimal para String no padrao solicitado do PagSeguro
  # Ex.:
  # PsIntegracao.to_dinheiro "0.5" ==> 50      #50 centavos
  # PsIntegracao.to_dinheiro "0.50 ==> 50      #50 centavos
  # PsIntegracao.to_dinheiro "0.05" ==> 05     #5 centavos
  # PsIntegracao.to_dinheiro "1" ==> 100       #1 real
  # PsIntegracao.to_dinheiro "1.0" ==> 100     #1 real
  #
  def self.to_dinheiro valor
    return nil if valor.nil?
    return nil if valor.class != String

    frac = valor.to_d.frac.to_s + "0"
    frac = frac[2,2]
    inteiro = ""
    inteiro = valor.to_i.to_s if (valor.to_i > 0)
    novo_valor = inteiro + frac.to_s
    
  end


  # Envia um post para o PagSeguro solicitando a autenticidade do post enviado pelo PagSeguro
  # Segundo a documentacao do PagSeguro, após o pagamento da compra, o sistema envia uma notificacao
  # via post para o site do lojista.
  # Este metodo é o responsavel por processar este post e conferir se os dados gravados na base de dados
  # local está igual ao enviado pelo PagSeguro
  # Caso tenha algo diferente retorna o Hash com a diferenca
  #
  # Ex.:
  # PsIntegracao.compara_post_notificacao request, cliente, items ==> ['Nome' => 'valor_antigo > novo_valor']
  def self.compara_post_notification request, ps_cliente, ps_items
    #TODO
    #TODO TEST
  end


  # Envia um post para o PagSeguro solicitando a autenticidade do post enviado pelo PagSeguro
  # Segundo a documentacao do PagSeguro, após o pagamento da compra, o sistema envia uma notificacao
  # via post para o site do lojista.
  # Este metodo é o responsavel por enviar um novo post ao PS, solicitando a autenticidade do post recebido 
  # informando o processamento da trasnacao, geramente a confirmacao de pagamento.
  #
  # Ex.:
  # PsIntegracao.confirma_autenticidade cliente, items ==> ['FRAUDE', 'Alteracao do status da transacao fraudulenta!']
  # PsIntegracao.confirma_autenticidade cliente, items ==> ['OK', 'Alteracao do status da transacao verificada!']  
  #
  def self.confirma_autenticidade ps_cliente, ps_items
    #TODO
    #TODO TEST
  end



end


class PsCliente
  attr_accessor :cliente_nome, :cliente_cep, :cliente_end, :cliente_num, :cliente_compl, :cliente_bairro, :cliente_cidade, :cliente_uf, :cliente_ddd, :cliente_tel, :cliente_email
end

class PsItem
  attr_accessor :id, :descricao, :quantidade, :valor, :peso
end
