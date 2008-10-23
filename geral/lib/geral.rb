$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

%w(item exceptions pedido cliente).each {|req| require File.dirname(__FILE__) + "/geral/#{req}"}


module Geral
end





