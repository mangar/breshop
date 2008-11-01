require 'uri'
require 'net/http'
require 'rexml/document'

class Correios

  #
  # Correios class can be initialized using a pre defined config file as parameter
  # if no one is specified, will be used the default: /../config/correios.yml
  #
  def initialize(pars = {})
    
    @config = (pars[:config].nil? ? YAML.load_file(File.dirname(__FILE__) + "/../config/correios.yml") : pars[:config])

    @params_config = {:resposta => "xml"}
    @params_config.merge!({:avisoRecebimento => "#{@config['aviso_recebimento']}"})
    @params_config.merge!({:MaoPropria => "#{@config['mao_propria']}"})
    @params_config.merge!({:servico => "#{@config['servico_padrao']}"})
    @params_config.merge!({:cepOrigem => "#{@config['cep_origem']}"})

    @uri = URI.parse(@config['url'])    
  end
  
  
  
    
  #
  # Calculates the freight based on brazilian delivery company called: Correios (www.correios.com.br)
  # 
  # Ex.:
  # correios = Correios.new
  # freight = correios.freight "14055-490", "0.300", "1500.00"  ==> freight price
  #
  # You can send not default info (info not configured into correios.yml)
  #
  # Ex.:
  # freight = correios.freight "14055-490", "0.300", "1500.00", {:servico => "Correios.SEDEX", :cepOrigem => "04515-030"}  ==> freight price
  #
  def freight (zip_destination, weight, price, pars = {})
  
    raise "Invalid Destination Zip Code (#{zip_destination})" if (zip_destination.nil? || zip_destination.empty?)
    raise "Invalid Weight (#{weight})" if (weight.nil? || weight.empty?)
    raise "Invalid Price (#{price})" if (price.nil? || price.empty?)
  
    #replace some parameters.....
    @params_config.merge!({:servico => pars[:servico]}) if pars.has_key?(:servico) 
    @params_config.merge!({:cepOrigem => pars[:cep_origem]}) if pars.has_key?(:cep_origem) 

    #insert some new ones.....
    @params_config.merge!({:cepDestino => zip_destination})
    @params_config.merge!({:peso => weight})
    @params_config.merge!({:valorDeclarado => price})    

    #sending requesto to Correios....
    url_pars = ""
    @params_config.each do |k,v|  url_pars += "&#{k}=#{v}" end
    
    response = Net::HTTP.get_response(URI.parse("#{@config['url']}#{url_pars}"))
    raise "Problem to get response. (#{response.code} - #{response.message})" unless response.kind_of?(Net::HTTPSuccess)
    
    doc = REXML::Document.new(response.body)

    # puts "#{doc}"
    
    freight = ""
    %w(descricao preco_postal).each do |elm|
      element = REXML::XPath.match(doc, "//#{elm}").first
      raise "Problems with parameters (#{element.text})" if ((elm.eql? 'descricao') && (!element.text.nil? && !element.text.empty?))
      freight = element.text if (elm.eql? 'preco_postal')
    end

    return freight  
  end
  
end