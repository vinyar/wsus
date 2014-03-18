# Installation of the Reporting service for WSUS

remote_file "c:/chef/ReportViewer.exe" do
	# file location: http://www.microsoft.com/en-us/download/details.aspx?id=577
  source "http://download.microsoft.com/download/0/9/d/09d3df2d-abec-4ebe-bc64-260b05a30feb/ReportViewer.exe"
end

windows_package "Microsoft Report Viewer Redistributable 2008 (KB952241)" do
    action :install
    installer_type :custom
    source 'c:/chef/ReportViewer.exe'
    options "/q /l c:\\chef\\ReportViewer_install.log"
    # not_if "type C:\\Users\\Opscode\\AppData\\Local\\Temp\\WSUSSetup.log |grep -i 'Windows Server Update Services setup completed successfully'"
    # require 'pry';binding.pry
end
