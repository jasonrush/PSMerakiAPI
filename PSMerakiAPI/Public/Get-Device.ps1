function Get-Device {
    <#
    .SYNOPSIS
        Returns all devices in a specified network or organization.
    .DESCRIPTION
        Returns all devices in a specified network or organization.
    .PARAMETER NetworkID
        The Network ID to return devices for.
    .PARAMETER OrganizationID
        The Organization ID to return devices for.
    .OUTPUTS
        Device object(s).
    .NOTES
        Version:        0.1
        Author:         Jason Rush
        Creation Date:  2019-11-19
        Purpose/Change: Initial script development
    .EXAMPLE
        Get-Device -NetworkID L_646829496481103996
    .EXAMPLE
        Get-Device -OrganizationID 549236
    #>
    param (
        [CmdletBinding(
            HelpURI = 'https://github.com/jasonrush/PSMerakiAPI/blob/master/Docs/Get-Device.md',
            SupportsPaging = $false,
            PositionalBinding = $false)]

        [Parameter(Mandatory = $true, ParameterSetName = 'NetworkID')]
        [ValidateNotNullOrEmpty()]
        [String] $NetworkID,

        [Parameter(Mandatory = $true, ParameterSetName = 'OrganizationID')]
        [ValidateNotNullOrEmpty()]
        [String] $OrganizationID
    )

    if ( ('NetworkID' -eq $PSCmdlet.ParameterSetName) -and ( '' -ne $NetworkID) ) {
        Write-Verbose "Filtering by Network ID: $ID"
        $Endpoint = "networks/$NetworkID/devices"
    }

    if ( ('OrganizationID' -eq $PSCmdlet.ParameterSetName) -and ( '' -ne $OrganizationID) ) {
        Write-Verbose "Filtering by Organization ID: $ID"
        $Endpoint = "organizations/$OrganizationID/devices"
    }

    try {
        $devices = Invoke-APIRestMethod -Endpoint $Endpoint
    }
    catch {
        # If a 404-not-found error is thrown, and we specified a NetworkID, return nothing.
        if ( 'The remote server returned an error: (404) Not Found.' -eq $_.Exception.Message ) {
            $devices = $null
            Write-Verbose "Network was not found."
        }
    }

    $devices
}
