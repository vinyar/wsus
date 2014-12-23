WSUS chef cookbook 
====

This will eventually become a WSUS cookbook

Chef cookbooks to deal with:
* Setting up and managing WSUS (Windows Server Update Service) server
* Connecting clients to a chef managed WSUS
* Getting updates
* other wsus related stuff.
* will have unit and integration tests
* with hopefully have windows TK integration
* will hapefully have pester integration as there is now a TK pester busser.


I took a first pass at this almost a year ago, and for the most part it worked.

The bugs in the original version:
In an AD controlled environment, a non-domained joined node was not able to receive updates.
Original version was aching to a gigantic powershell script with almost no knobs.

Someone wrote a pretty good WSUS cookbook here.
* https://github.com/criteo-cookbooks/wsus-server
* https://github.com/criteo-cookbooks/wsus-client

