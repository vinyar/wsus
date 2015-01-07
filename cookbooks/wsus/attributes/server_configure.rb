default['wsus']['config']['admin_user'] = 'TestAdmin123'
default['wsus']['config']['admin_pass'] = 'TestAdmin123456789!!'

default['wsus']['config']['basic_user'] = 'TestUser123'
default['wsus']['config']['basic_pass'] = 'TestUser123456789!!'

default['wsus']['config']['admin_group'] = 'WSUS Administrators'
default['wsus']['config']['admin_group_members'] = 'TestAdmin123'

default['wsus']['config']['reporter_group'] = 'WSUS Reporters'
default['wsus']['config']['reporter_group_members'] = 'TestUser123'

# this can be an array = either standard [] or %w{}
default['wsus']['config']['primary']['languages'] = 'en'