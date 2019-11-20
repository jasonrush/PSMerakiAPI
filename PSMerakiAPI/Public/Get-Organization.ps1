function Get-Organization {
    <#
    .SYNOPSIS
        Returns all organizations or a specified organization.
    .DESCRIPTION
        Returns all organizations the specified API key has access to.
        If an Organization ID is specified, will instead return the individual organization.
    .PARAMETER ID
        The Organization ID of the organization to return.
    .PARAMETER Name
        The Organization ID of the organization to return.
    .OUTPUTS
        Organization object(s).
    .NOTES
        Version:        0.1
        Author:         Jason Rush
        Creation Date:  2019-11-19
        Purpose/Change: Initial script development
    .EXAMPLE
        Get-Organization
    .EXAMPLE
        Get-Organization -ID "537758"
    .EXAMPLE
        Get-Organization -Name "DevNet Sandbox"
    #>
    param (
        [CmdletBinding(
            HelpURI = 'https://github.com/jasonrush/PSMerakiAPI/blob/master/Docs/Get-Organization.md',
            DefaultParameterSetName = 'ID',
            SupportsPaging = $false,
            PositionalBinding = $false)]

        [Parameter(ParameterSetName = 'ID')]
        [ValidateNotNullOrEmpty()]
        [String] $ID,

        [Parameter(Mandatory = $true, ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [String] $Name
    )

    $Endpoint = 'organizations'

    if ( ('ID' -eq $PSCmdlet.ParameterSetName) -and ( '' -ne $ID) ) {
        Write-Verbose "Filtering by ID: $ID"
        $Endpoint += "/$ID"
    }

    try {
        $organizations = Invoke-APIRestMethod -Endpoint $Endpoint
    }
    catch {
        # If a 404-not-found error is thrown, and we specified an ID, return nothing.
        if ( 'The remote server returned an error: (404) Not Found.' -eq $_.Exception.Message ) {
            if ( ('ID' -eq $PSCmdlet.ParameterSetName) -and ( '' -ne $ID) ) {
                $organizations = $null
            }
        }
    }

    if ( 'Name' -eq $PSCmdlet.ParameterSetName ) {
        Write-Verbose "Filtering by name: $Name"
        $organizations = $organizations | Where-Object { $_.name -eq $Name } | Select-Object -First 1
    }

    $organizations
}
