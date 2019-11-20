<#
Rate Limit
The Dashboard API is limited to 5 calls per second, per organization.
A burst of 5 additional calls are allowed in the first second, so a maximum of 15 calls in the first 2 seconds.
The rate limiting technique is based off of the token bucket model.
An error with a 429 status code will be returned when the rate limit has been exceeded.
Expect to backoff for 1 - 2 seconds if the limit has been exceeded. You may have to wait potentially longer if a large number of requests were made within this timeframe.
Rate Limit Error Handling
​If the defined rate limit is exceeded, Dashboard API will reply with the 429 (rate limit exceeded) error code. This response will also return a Retry-After header indicating how long the client should wait before making a follow-up request.​

The Retry-After key contains the number of seconds the client should delay.​
Expect to backoff for 1 - 2 seconds if the limit has been exceeded. You may have to wait potentially longer if a large number of requests were made within this timeframe.​A simple example which minimizes rate limit errors:​
response = requests.request("GET", url, headers=headers)
​
if response.status_code == 200:
	# Success logic
elif response.status_code == 429:
	time.sleep(int(response.headers["Retry-After"]))
else:
	# Handle other response codes

#>

function Invoke-APIRestMethod {
    <#
    .SYNOPSIS
        Makes a REST call to the Meraki API
    .DESCRIPTION
        Connects to the Meraki API via REST and returns results as object(s).
        This function is used internally by most other calls to the Meraki API through this module.
    .PARAMETER Method
        'GET', 'POST', 'PUT', or 'DELETE'. Defaults to 'GET'.
    .PARAMETER Endpoint
        The API endpoint to access (after the API base URL, ie. after 'https://api.meraki.com/api/v0/').
    .PARAMETER Body
        HTTP request body, if required.
    .OUTPUTS
        PowerShell objects based on the JSON data returned by the API call.
    .NOTES
        Version:        1.0
        Author:         Jason Rush
        Creation Date:  2019-11-19
        Purpose/Change: Initial script development

    .EXAMPLE
        Invoke-APIRestMethod -Endpoint 'organizations'
    #>
    param (
        [CmdletBinding(
        HelpURI='https://github.com/jasonrush/PSMerakiAPI/blob/master/Docs/Invoke-APIRestMethod.md',
        SupportsPaging=$false,
        PositionalBinding=$true)]

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $Endpoint,

        [Parameter()]
        [ValidateSet('GET','POST','PUT','DELETE')]
        [String] $Method = "GET",

        [Parameter()]
        $Body,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String] $ApiKey = '',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String] $BaseURI = ''
        #>
    )
    
    # If no API key specified, try pulling from Environment variable.
    if( ('' -eq $ApiKey) -and ( Test-Path env:MerakiApiKey) ){
        Write-Verbose "Importing API key from environmental variable."
        $ApiKey = $env:MerakiApiKey
    }

    # If BaseURI was not specified, try pulling from Environment variable.
    if( ('' -eq $BaseURI) -and ( Test-Path env:MerakiApiBaseURI) ){
        Write-Verbose "Importing Base URI from environmental variable."
        $BaseURI = $env:MerakiApiBaseURI
    }

    # If there was no base URI in the Environment variable, try figuring out automagically.
    if( ('' -eq $BaseURI) ){
        Write-Verbose "Importing Base URI from Meraki API call (via Invoke-WebRequest)."
        $organizationsURI = 'https://api.meraki.com/api/v0/organizations'
        try {
            $webRequest = Invoke-WebRequest -Uri $organizationsURI -Headers @{"X-Cisco-Meraki-API-Key" = $ApiKey}
            $BaseURI = ($webRequest.BaseResponse.ResponseUri.AbsoluteUri).Replace( '/organizations', '' )
            $env:MerakiApiBaseURI = $BaseURI
            Write-Verbose "New base URI: $BaseURI"
        }
        catch {
            Write-Verbose "Attempting to track down shard-based base URI via redirect failed."
        }
        Write-Verbose "WAT"
    }

    # If we still haven't figured out a better base URI, use the default.
    if( ('' -eq $BaseURI) ){
        $BaseURI = 'https://api.meraki.com/api/v0'
    }

    # Create headers array to specify Meraki API key
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    if( $null -eq $ApiKey ){
        # ERROR
    }

    Write-Verbose "Method: $Method"

    $FullURI = "$BaseURI/$Endpoint"
    Write-Verbose "Path: $FullURI"

    Write-Verbose "API Key: $ApiKey"
    $headers.Add( "X-Cisco-Meraki-API-Key", $ApiKey )

    Write-Verbose "Headers:"
    foreach( $key in $headers.Keys ){
        Write-Verbose "`t`t$($key): $($headers[$key])"
    }

    <#
    Write-Verbose "Body:"
    foreach( $key in $headers.Keys ){
        Write-Verbose "`t`t$($key): $($headers[$key])"
    }
    #>

    # Meraki does not accept API connections using older versions of TLS.
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    try {
        $response = Invoke-RestMethod $FullURI -Method $Method -Headers $Headers -Body $Body -ErrorAction Continue
    }
    catch {
        switch( $_.Exception.Message ){
            'The remote server returned an error: (404) Not Found.' {
                Write-Verbose "A 404-not-found error was returned."
                throw 'The remote server returned an error: (404) Not Found. Verify your endpoint/URL and API key.'
                Break
            }
            default {
                throw $_
            }
        }
    }

    return $response
}
