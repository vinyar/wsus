wsus_wrapper CHANGELOG
======================

0.2.0
major refactor
minimum needed chef 11.16.x - 
 -- one major reason is a bug associated with remote_file not properly working with network shares. During local testing it wouldn't work with mapped network shares (ex: z:/bin/installer.exe)

0.1.0 - initial version
install server
configure server