$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

%w(item exceptions sale buyer).each {|req| require File.dirname(__FILE__) + "/general/#{req}"}


module Geral
end





