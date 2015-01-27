# Full list of attributes - http://support.microsoft.com/kb/947034

#Generic attributes
default['ad']['domain_name']        = 'testdomain.com'
default['ad']['netbios_name']       = 'testdomain'
default['ad']['type']               = 'forest'
# default['ad']['site_name']        = 'Opscode'
# - removed from template forest -  SiteName=<%= @site_name %>

#Forest specifc attributes
default['ad']['admin_password']     = 'Opscode123!'
## set to nil and use role or databag to overwrite?


#Child specific attributes
default['ad']['child_name']         = 'testdomain_child'
default['ad']['dns_user_name']      =  nil
default['ad']['dns_user_password']  = "nothing"


#Child & Replica attributes
default['ad']['user_name']          = "nothing"
default['ad']['user_domain']        = "nothing"
default['ad']['user_password']      = "nothing"

# For reboot Handler to work
default['windows']['allow_pending_reboots'] = true

# [DCINSTALL] 
# InstallDNS=yes
# NewDomain=forest
# NewDomainDNSName=<The fully qualified Domain Name System (DNS) name>
# DomainNetBiosName=<By default, the first label of the fully qualified DNS name>
# SiteName=<Default-First-Site-Name>
# ReplicaOrNewDomain=domain
# ForestLevel=<The forest functional level number>
# DomainLevel=<The domain functional level number>
# DatabasePath="<The path of a folder on a local volume>" 
# LogPath="<The path of a folder on a local volume>" 
# RebootOnCompletion=yes
# SYSVOLPath="<The path of a folder on a local volume>" 
# SafeModeAdminPassword=<The password for an offline administrator account>