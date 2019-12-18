function Get-Admin {
    <#
    .SYNOPSIS
        Returns all network and/or organization administrators.
    .DESCRIPTION
        Returns all network and/or organization administrators.
    .PARAMETER ID
        The Organization ID to return networks for.
    .OUTPUTS
        Admin object(s).
    .NOTES
        Version:        0.1
        Author:         Jason Rush
        Creation Date:  2019-12-17
        Purpose/Change: Initial script development
    .EXAMPLE
        Get-Admins -ID 549236
    #>
    param (
        [CmdletBinding(
            HelpURI = 'https://github.com/jasonrush/PSMerakiAPI/blob/master/Docs/Get-Admins.md',
            SupportsPaging = $false,
            PositionalBinding = $false)]

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $OrganizationID
    )

    Write-Verbose "Filtering by Organization ID: $OrganizationID"
    $Endpoint = "organizations/$OrganizationID/admins"

    try {
        $admins = Invoke-APIRestMethod -Endpoint $Endpoint
    }
    catch {
        # If a 404-not-found error is thrown, return nothing.
        if ( 'The remote server returned an error: (404) Not Found.' -eq $_.Exception.Message ) {
            Write-Verbose "Organization admins not found."
        }
    }

    $admins
}
