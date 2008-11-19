require 'fileutils'
 
breshop_yml_file = File.dirname(__FILE__) + '/../../../config/breshop.yml'
FileUtils.cp File.dirname(__FILE__) + '/install/breshop.yml', breshop_yml_file unless File.exist?(breshop_yml_file)