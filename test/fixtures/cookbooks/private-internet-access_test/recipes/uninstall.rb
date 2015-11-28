# Encoding: UTF-8

include_recipe 'private-internet-access'

private_internet_access 'default' do
  action :remove
end
