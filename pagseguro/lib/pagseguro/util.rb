module Util
  Object.class_eval do
    #TODO Traduzir para ingles............
    # Formata o campo de decimal para String no padrao solicitado do PagSeguro
    # Ex.:
    # integracao.to_peso "0.5" ==> 500      #500 gramas
    # integracao.to_peso "0.50 ==> 500     #500 gramas
    # integracao.to_peso "0.05" ==> 050     #50 gramas
    # integracao.to_peso "0.005" ==> 005    #5 gramas
    # integracao.to_peso "1" ==> 1000       #1 kilo
    # integracao.to_peso "1.0" ==> 1000     #1 kilo
    #
    def to_ps_weight
      return nil if self.nil?
      return "000" if self.to_f == 0
      
      value = self.to_s

      # obtem a parte fracionaria e transforma em string.
      frac = value.to_f - value.to_i
      frac = frac.to_s + "00"         
      frac = frac[2..4]
      inteiro = ""
      inteiro = value.to_i.to_s if (value.to_f.truncate > 0)
      inteiro + frac.to_s
    end


    # TODO traduzir para ingles................
    # Formata o campo de decimal para String no padrao solicitado do PagSeguro
    # Ex.:
    # integracao.to_dinheiro "0.5" ==> 50      #50 centavos
    # integracao.to_dinheiro "0.50 ==> 50      #50 centavos
    # integracao.to_dinheiro "0.05" ==> 05     #5 centavos
    # integracao.to_dinheiro "1" ==> 100       #1 real
    # integracao.to_dinheiro "1.0" ==> 100     #1 real
    #
    def to_ps_money
       return nil if self.nil?
       return "00" if self.to_f == 0
       
       value = self.to_s

       # obtem a parte fracionaria e transforma em string.
       frac = value.to_f - value.to_i
       frac = frac.to_s + "0"         
       frac = frac[2..3]
       # Se tiver parte inteira, concatena com a parte fracionaria
       inteiro = ""
       inteiro = value.to_i.to_s if value.to_f.truncate > 0
       inteiro + frac
    end
  end
end