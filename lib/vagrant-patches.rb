begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant Patches plugin must be run within vagrant.'
end
if Vagrant::VERSION < '1.6.5'
  raise 'The Vagrant Patches plugin has only been tested with vagrant 1.6.5'
end

require "vagrant-patches/version"
require "vagrant-patches/issue-4465"
require "vagrant-patches/issue-4494"
