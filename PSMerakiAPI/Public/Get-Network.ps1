function Get-Network {
    <#
    .SYNOPSIS
        Returns all networks or a specified network in an organization.
    .DESCRIPTION
        Returns all networks or a specified network in an organization.
    .PARAMETER NetworkID
        The Network ID of the network to return.
    .PARAMETER OrganizationID
        The Organization ID to return networks for.
    .PARAMETER Name
        The network name to return (within the organization specified by OrganizationID).
    .OUTPUTS
        Network object(s).
    .NOTES
        Version:        0.1
        Author:         Jason Rush
        Creation Date:  2019-11-19
        Purpose/Change: Initial script development
    .EXAMPLE
        Get-Network -NetworkID L_646829496481103996
    .EXAMPLE
        Get-Network -OrganizationID 549236
    #>
    param (
        [CmdletBinding(
        HelpURI='https://github.com/jasonrush/PSMerakiAPI/blob/master/Docs/Get-Network.md',
        SupportsPaging=$false,
        PositionalBinding=$false)]

        [Parameter(Mandatory=$true, ParameterSetName='NetworkID')]
        [ValidateNotNullOrEmpty()]
        [String] $NetworkID,

        [Parameter(Mandatory=$true, ParameterSetName='OrganizationID')]
        [ValidateNotNullOrEmpty()]
        [String] $OrganizationID,

        [Parameter(ParameterSetName='OrganizationID')]
        [ValidateNotNullOrEmpty()]
        [String] $Name = ''
    )

    if( ('NetworkID' -eq $PSCmdlet.ParameterSetName) -and ( '' -ne $NetworkID) ){
        Write-Verbose "Filtering by Network ID: $ID"
        $Endpoint = "networks/$NetworkID"
    }

    if( ('OrganizationID' -eq $PSCmdlet.ParameterSetName) -and ( '' -ne $OrganizationID) ){
        Write-Verbose "Filtering by Organization ID: $ID"
        $Endpoint = "organizations/$OrganizationID/networks"
    }

    try {
        $networks = Invoke-APIRestMethod -Endpoint $Endpoint    
    }
    catch {
        # If a 404-not-found error is thrown, and we specified a NetworkID, return nothing.
        if( 'The remote server returned an error: (404) Not Found.' -eq $_.Exception.Message ){
            if( ('NetworkID' -eq $PSCmdlet.ParameterSetName) -and ( '' -ne $ID) ){
                $networks = $null
                Write-Verbose "Network was not found."
            }
        }
    }

    if( '' -ne $Name ){
        Write-Verbose "Filtering by name: $Name"
        $networks = $networks | Where-Object { $_.name -eq $Name } | Select-Object -First 1
    }

    $networks
}
