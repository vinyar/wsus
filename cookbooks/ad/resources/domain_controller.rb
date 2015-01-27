actions :install, :configure, :uninstall

attribute :type, :kind_of => String, :default => "forest"
attribute :name, :kind_of => String, :name_attribute => true

#add validation - accepted types, values.
#Type (only - forest, child, replica are allowed)
# Make password required attriute


default_action :install