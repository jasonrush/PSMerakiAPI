Import-Module "$(Split-Path -parent $MyInvocation.MyCommand.Path)/../PSMerakiAPI/PSMerakiAPI.psm1" -Prefix "PSMAPI"

$env:MerakiAPIKey = '093b24e85df15a3e66f1fc359f4c48493eaa1b73' # Demo Read-only API key

Describe 'Get-Organization Tests' {
    Context 'Verify proper result counts' {
        It 'Returns one or more results with no parameters' {
            (Get-PSMAPIOrganization).count | Should -BeGreaterThan 0
        }
        It 'Returns a single result when ID is specified' {
            Get-PSMAPIOrganization -ID 537758 | Should -HaveCount 1
        }
        It 'Returns a single result when Name is specified' {
            Get-PSMAPIOrganization -Name 'DevNet Sandbox' | Should -HaveCount 1
        }
        It 'Throws an exception when a blank ID is specified' {
            {Get-PSMAPIOrganization -ID ''} | Should -Throw
        }
        It 'Throws an exception when a blank Name is specified' {
            {Get-PSMAPIOrganization -Name ''} | Should -Throw
        }
        It 'Returns no results when a gibberish ID is specified' {
            Get-PSMAPIOrganization -ID 'qwertyqwertyqwerty' | Should -BeNullOrEmpty
        }
        It 'Returns no results when a gibberish Name is specified' {
            Get-PSMAPIOrganization -Name 'qwertyqwertyqwerty' | Should -BeNullOrEmpty
        }
    }

    Context "Organization object has the correct properties" {
        $orgObject = Get-PSMAPIOrganization -Name 'DevNet Sandbox'

        # Load an array with the properties we need to look for
        $properties = ('id', 'name', 'url')

        foreach ($property in $properties){
            It "Organization objects should have a property of $property" {
                [bool]($orgObject.PSObject.Properties.Name -match $property) | Should -BeTrue
            }
        }

        It "Organization objects should not have a gibberish property" {
            [bool]($orgObject.PSObject.Properties.Name -match 'qwertyqwertyqwerty') | Should -not -BeTrue
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
