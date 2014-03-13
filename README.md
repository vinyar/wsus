<<<<<<< HEAD
wsus Cookbook
=============
This is a Chef cookbook to setup a Windows Update (WSUS) server and configure a client to connect to it.

This cookbook contains multiple recipes to accomplish a task:
  default - will evaluate node['wsus']['server'] and either configure a server or client. Client configureation will be done based on search. If no WSUS managed by Chef is found, client recipe will exit.
  server - will download and install WSUS components and configure the server.
  configure_wsus - will configure the server (called by server recipe)
  reportviewer - per request, report viewer installation was carved out into its own recipe.
  server_cleanup - untested & experimental recipe.


Requirements
------------
Windows 2008 server. Best if used with a wrapper cookbook specific to your org to overwrited defaults.


Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### wsus::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['wsus']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### wsus::server

Just include `wsus` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[wsus::server]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Alex Vinyar
=======
wsus
====

Chef cookbooks to deal with setting up WSUS (Windows Server Update Service) server
>>>>>>> bc42b36d9e31cdfd8e84766dab34700dcecf20a4
