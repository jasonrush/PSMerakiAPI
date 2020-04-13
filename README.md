[![Build status](https://ci.appveyor.com/api/projects/status/4090s4bm37vr4c34?svg=true)](https://ci.appveyor.com/project/jasonrush/psmerakiapi)

# PSMerakiAPI
Another PowerShell module to interact with the Meraki API. This is still *very* alpha, but I hope to make it a much more feature-rich and thorough implementation than any others I've found to date (as time allows, that is).

# Usage
The module is currently designed to authenticate by using a copy of your Meraki API key stored in an environment variable. Once the API key is stored in the variable, all PSMerakiAPI functions should be usable.

Instructions on how to generate an API key within Merkai can be found here: https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API#Enable_API_access
```
PS> $env:MerakiApiKey = 'xxxxxxxxxxc0a913fxxxxxxxxe19f6axxxxxxxxxx'
PS> Get-Organization


id                 name          url
--                 ----          ---
56407585xxxxxxxxxx Demo Org Name https://n123.meraki.com/o/xxxxxxx/manage/organization/overview


PS> 