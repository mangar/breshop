require 'rubygems'
require 'uri'
require 'net/http'
require 'net/https'
require 'hpricot'

class Sales
  def initialize(args = {})
    @package = args[:items].to_params 
    @package << "tipo=#{args[:config]['tipo_carrinho']}"
    @package << "moeda=#{args[:config]['moeda']}"
    @package << "email_cobranca=#{args[:config]['email_cobranca']}"
    @package << "tipo_frete=#{args[:shipping]}"
    @package << "cliente_cep=#{args[:destiny]}"
    
    @uri = URI.parse(args[:config]['webpagto'])
  end
  
  def parameters
    @package.join("&")
  end
  
  def shipping
    http = Net::HTTP.new(@uri.host, 443)
    http.use_ssl = true
    
    resp, html = http.get("#{@uri.path}?#{parameters}", nil)
    
    @source = Hpricot(html)
    
    (@source/"#lblValorFrete").first.inner_html
  end
end