#
# Cookbook Name:: wsus
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node['wsus']['server']
when true
  include_recipe 'wsus::server'
else
  if search(:nodes, "wsus.server:true").nil
  	# # knife search "role:wsus_srv" -a node.cloud.public_hostname
  	log "no WSUS server found"
  else
    include_recipe 'wsus::client'
  end
end




# Scripting snippets for WSUS
# http://gallery.technet.microsoft.com/scriptcenter/site/search?query=wsus&f%5B0%5D.Value=wsus&f%5B0%5D.Type=SearchText&ac=4

# Investigate:
# What are KB2734608 and KB2720211 and are they needed?