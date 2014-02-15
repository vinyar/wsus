#
# Cookbook Name:: wsus
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if node['wsus']['installation_target']
  include_recipe 'server'
end



# Scripting snippets for WSUS
# http://gallery.technet.microsoft.com/scriptcenter/site/search?query=wsus&f%5B0%5D.Value=wsus&f%5B0%5D.Type=SearchText&ac=4

# Investigate:
# What are KB2734608 and KB2720211 and are they needed?