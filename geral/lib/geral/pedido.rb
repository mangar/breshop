# require 'rubygems'
# require 'uri'
# require 'net/http'
# require 'net/https'
# require 'hpricot'

class Pedido

  attr_accessor :codigo, :cliente, :frete, :cep1, :cep2, :tipo_frete
  attr_reader :itens

#TODO testar este contrutor....
  def initialize(params = {})
    @codigo = params[:codigo]
    @cliente = params[:cliente]
    @frete = params[:frete]
    @itens = {}
    @itens = params{:itens} if (params.has_key?(:itens))
  end


  # Inclui um novo item ao pedido ou adiciona um item (quantidade)
  # caso o item já esteja registrado no pedido
  # O parametro deve ser um Item, caso nao seja, levantara ItemInvalido Exception
  #
  # Ex.:
  # pedido << item
  def <<(item)    
    return if (item.nil?)
    raise ItemInvalido unless item.class.eql? Item

    #item consta no pedido....
    if (@itens.has_key?(item.codigo))
      
      #quantidade zerada, remover...
      @itens.delete item.codigo if (item.quantidade == 0)

      #altera a quantidade
      @itens[item.codigo].quantidade = item.quantidade if (item.quantidade > 0)
      
    else
      @itens[item.codigo] = item
    end

  end

  # Retorna o valor total dos produtos inseridos no carrinho de compras
  def valor
    valor = 0
    return valor if (@itens.size == 0)
    @itens.values.each do |item| valor += item.valor_total end
    valor += (@frete.nil? ? 0 : @frete)
    valor
  end
  
  # Retorna o peso total dos produtos inseridos no carrinho de compras
  def peso
    peso = 0
    return peso if (@itens.size == 0)
    @itens.values.each do |item| peso += item.peso_total end
    peso
  end

  
  
  
  # def to_frete
  # end
  # 
  # def to_checkout
  # end
  
  # def initialize(args = {})
  #   @package = args[:items].to_params 
  #   @package << "tipo=#{args[:config]['tipo_carrinho']}"
  #   @package << "moeda=#{args[:config]['moeda']}"
  #   @package << "email_cobranca=#{args[:config]['email_cobranca']}"
  #   @package << "tipo_frete=#{args[:shipping]}"
  #   @package << "cliente_cep=#{args[:destiny]}"
  #   
  #   @uri = URI.parse(args[:config]['webpagto'])
  # end
  # 
  # def parameters
  #   @package.join("&")
  # end
  # 
  # def shipping
  #   http = Net::HTTP.new(@uri.host, 443)
  #   http.use_ssl = true
  #   
  #   resp, html = http.get("#{@uri.path}?#{parameters}", nil)
  #   
  #   @source = Hpricot(html)
  #   
  #   (@source/"#lblValorFrete").first.inner_html
  # end
end