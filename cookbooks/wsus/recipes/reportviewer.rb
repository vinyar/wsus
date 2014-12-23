# Installation of the Reporting service for WSUS

remote_file node['wsus']['report_package_local_location'] do
  source node['wsus']['report_package_source']
end

windows_package "Microsoft Report Viewer Redistributable 2008 (KB952241)" do
    action :install
    installer_type :custom
    source node['wsus']['report_package_local_location']
    options "/q /l c:\\chef\\ReportViewer_install.log"
    # not_if "type C:\\Users\\Opscode\\AppData\\Local\\Temp\\WSUSSetup.log |grep -i 'Windows Server Update Services setup completed successfully'"
    # require 'pry';binding.pry
end
