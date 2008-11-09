$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

%w(integration util).each {|req| require File.dirname(__FILE__) + "/pagseguro/#{req}"}

module Pagseguro
  extend Util
end





