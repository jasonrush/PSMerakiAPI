Import-Module "$(Split-Path -parent $MyInvocation.MyCommand.Path)/../PSMerakiAPI/PSMerakiAPI.psm1" -Prefix "PSMAPI"

$env:MerakiAPIKey = '093b24e85df15a3e66f1fc359f4c48493eaa1b73' # Demo Read-only API key

Describe 'Get-Admin Tests' {
    Context 'Verify proper result counts' {
        It 'Returns one or more results when OrganizationID is specified' {
            ((Get-PSMAPIAdmin -OrganizationID 537758).Count -gt 0) | Should -BeTrue
        }
        It 'Throws an exception when a blank OrganizationID is specified' {
            { Get-PSMAPIAdmin -OrganizationID '' } | Should -Throw
        }
        It 'Returns no results when a gibberish ID is specified' {
            Get-PSMAPIAdmin -OrganizationID 'qwertyqwertyqwerty' | Should -BeNullOrEmpty
        }
    }

    Context "Admin object has the correct properties" {
        $admObject = (Get-PSMAPIAdmin -OrganizationID 537758 | Select-Object -First 1)

        # Load an array with the properties we need to look for
        $properties = ('name', 'email', 'id', 'networks', 'tags', 'twoFactorAuthEnabled', 'lastActive', 'accountStatus', 'hasApiKey', 'orgAccess')

        foreach ($property in $properties) {
            It "Organization objects should have a property of $property" {
                [bool]($admObject.PSObject.Properties.Name -match $property) | Should -BeTrue
            }
        }

        It "Organization objects should not have a gibberish property" {
            [bool]($admObject.PSObject.Properties.Name -match 'qwertyqwertyqwerty') | Should -not -BeTrue
        }
    } # Context correct properties

    <# This seems to only work for Pester v4+?
    Context "Verify parameters" {
        It 'Has parameter [string]ID' {
            Get-Command Get-PSMAPIOrganization | Should -HaveParameter ID -Type String
        }
        It 'Has parameter [string]Name' {
            Get-Command Get-PSMAPIOrganization | Should -HaveParameter Name -Type String
        }
    }
    #>
}
