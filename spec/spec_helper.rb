require 'serverspec'
require 'net/ssh'
require 'net/ssh/proxy/command'
require 'json'

terraform = JSON.parse(`terraform output -json`)
jumpbox_host = terraform['jumpbox_address']['value']
jumpbox_user = terraform['jumpbox_user']['value']
private_key  = terraform['private_key']['value']

proxy = Net::SSH::Proxy::Command.new("ssh -o 'StrictHostKeyChecking no' -i #{private_key} #{jumpbox_user}@#{jumpbox_host} nc %h %p")

set :backend, :ssh
set :sudo_password, ENV['SUDO_PASSWORD']

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

options[:proxy] = proxy
options[:user]  = jumpbox_user
options[:keys]  = private_key

set :host,        options[:host_name] || host
set :ssh_options, options

set :request_pty, true

# Disable sudo
# set :disable_sudo, true

# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
