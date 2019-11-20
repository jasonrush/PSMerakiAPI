function Verb-Noun {
    <#
    .SYNOPSIS
        Does a thing.
    .DESCRIPTION
        This function does a thing, but can do additional things when additional parameters are passed.
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
        HelpURI='https://github.com/jasonrush/PSMerakiAPI/blob/master/Docs/Verb-Noun.md',
        DefaultParameterSetName='ID',
        SupportsPaging=$false,
        PositionalBinding=$false)]

        [Parameter(ParameterSetName='ID')]
        [ValidateNotNullOrEmpty()]
        [String] $ID,

        [Parameter(Mandatory=$true, ParameterSetName='Name')]
        [ValidateNotNullOrEmpty()]
        [String] $Name
    )

    # DO THINGS

    try {
        $organizations = Invoke-APIRestMethod -Endpoint $Endpoint    
    }
    catch {
        # If a 404-not-found error is thrown, and we specified an ID, return nothing.
        if( 'The remote server returned an error: (404) Not Found.' -eq $_.Exception.Message ){
            if( ('ID' -eq $PSCmdlet.ParameterSetName) -and ( '' -ne $ID) ){
                $organizations = $null
            }
        }
    }

    # DO ADDITIONAL THINGS

    $organizations
}
