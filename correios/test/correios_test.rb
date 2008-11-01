require 'test/unit'
require 'yaml'

require File.dirname(__FILE__) + '/../lib/correios'

class CorreiosTest < Test::Unit::TestCase
  
  
  
  def setup
    
    @config = YAML.load_file(File.dirname(__FILE__) + '/correios_test.yml')
  end
  
  
  
  def test_shipment_calculate
    
    correios = Correios.new ({:config => @config})
    
    #zip_destination, weight and total proce can not be nil...
    assert_raise RuntimeError do correios.freight nil, nil, nil; end
    
    #...neighter blank!
    assert_raise RuntimeError do correios.freight "", "", ""; end
    
    assert_equal('22.3', correios.freight("14055-490", "0.300", "1560.00"), "Check the freight price, may be it can be changed.")
    
    # Invalid service code!
    assert_raise RuntimeError do correios.freight("14055-490", "0.300", "1560.00", {:servico => "aaaa"}); end
    
    # Invalid Origin ZipCode
    assert_raise RuntimeError do correios.freight("14055-490", "0.300", "1560.00", {:cep_origem => ""}); end

    correios = Correios.new ({:config => @config})
    assert_equal('22.3', correios.freight("14055-490", "0.300", "1560.00", {:servico => "41106", :cep_origem => "04515-030"}), "Check the freight price, may be it can be changed.")

 
  end
  
  
  
  
end