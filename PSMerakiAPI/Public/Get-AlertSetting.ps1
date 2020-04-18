function Get-AlertSetting {
    <#
    .SYNOPSIS
        Returns alert configuration in a specified network.
    .DESCRIPTION
        Returns alert configuration in a specified network.
    .PARAMETER NetworkID
        The Network ID to return alert configuration for.
    .OUTPUTS
        alert configuration object(s).
    .NOTES
        Version:        0.1
        Author:         Jason Rush
        Creation Date:  2020-04-18
        Purpose/Change: Initial script development
    .EXAMPLE
        Get-AlertSetting -NetworkID L_646829496481103996
    #>
    param (
        [CmdletBinding(
            HelpURI = 'https://github.com/jasonrush/PSMerakiAPI/blob/master/Docs/Get-AlertSetting.md',
            SupportsPaging = $false,
            PositionalBinding = $false)]

        [Parameter(Mandatory = $true, ParameterSetName = 'NetworkID')]
        [ValidateNotNullOrEmpty()]
        [String] $NetworkID
    )

    Write-Verbose "Filtering by Network ID: $ID"
    $Endpoint = "networks/$NetworkID/alertSettings"

    try {
        $alertSettings = Invoke-APIRestMethod -Endpoint $Endpoint
    }
    catch {
        # If a 404-not-found error is thrown, and we specified a NetworkID, return nothing.
        if ( 'The remote server returned an error: (404) Not Found.' -eq $_.Exception.Message ) {
            $alertSettings = $null
            Write-Verbose -Message "Alert configuration was not found."
        }
    }

    $alertSettings
}
