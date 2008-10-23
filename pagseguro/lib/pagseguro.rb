$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

%w(ps_integracao).each {|req| require File.dirname(__FILE__) + "/pagseguro/#{req}"}


module Pagseguro
end





