# Serversetup overrides
# node.override['wsus']['wsus_package_source']   = 'file:///z:/wsus/WSUS30-KB972455-x64.exe' - breaks
node.override['wsus']['wsus_package_source']   = 'file://C:/parent_binaries/wsus/WSUS30-KB972455-x64.exe'
# node.override['wsus']['wsus_package_source']   = 'file://vboxsvr/c%3A_local_binaries/wsus/WSUS30-KB972455-x64.exe' - also broken
# node.override['wsus']['sp_package_source']   = 'file://C:/local_binaries/wsus/WSUS-KB2828185-x86.exe' - seems like this is wrong for x64
node.override['wsus']['sp_package_source']   = 'file://C:/parent_binaries/wsus/WSUS-KB2828185-amd64.exe'
node.override['wsus']['report_package_source'] = 'file://C:/parent_binaries/wsus/ReportViewer.exe'

# node.override['wsus']['wsus_package_local_location']   = 'c:\\var\\chef\\cache\\WSUS30-KB972455-x86.exe'
# node.override['wsus']['wsus_package_local_location']   = '\\var\\chef\\cache\\WSUS30-KB972455-x86.exe'
# node.override['wsus']['sp_package_local_location']     = File.join(node['wsus']['package_local_root'],File.basename(node['wsus']['sp_package_source'])).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR || '\\')
# node.override['wsus']['report_package_local_location'] = File.join(node['wsus']['package_local_root'],File.basename(node['wsus']['report_package_source'])).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR || '\\')


### Client overrides
node.override['wsus']['wsus_server_url'] = 'http://localhost:23456'