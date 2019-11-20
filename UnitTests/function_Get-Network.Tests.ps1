Import-Module "$(Split-Path -parent $MyInvocation.MyCommand.Path)/../PSMerakiAPI/PSMerakiAPI.psm1" -Prefix "PSMAPI"

$env:MerakiAPIKey = '093b24e85df15a3e66f1fc359f4c48493eaa1b73' # Demo Read-only API key

Describe 'Get-Network Tests' {
    Context 'Verify proper result counts' {
        It 'Throws an exception with no parameters' {
            {Get-PSMAPINetwork} | Should -Throw
        }
        It 'Returns one or more results when OrganizationID is specified' {
            (Get-PSMAPINetwork -OrganizationID 549236).count | Should -BeGreaterThan 0
        }
        It 'Returns a single result when NetworkID is specified' {
            Get-PSMAPINetwork -NetworkID L_646829496481099586 | Should -HaveCount 1
        }
        It 'Returns a single result when OrganizationID and Name are specified' {
            Get-PSMAPINetwork -OrganizationID 549236 -Name 'DevNet Always On Read Only' | Should -HaveCount 1
        }
        It 'Throws an exception when a blank NetworkID is specified' {
            {Get-PSMAPINetwork -NetworkID ''} | Should -Throw
        }
        It 'Throws an exception when a blank OrganizationID is specified' {
            {Get-PSMAPINetwork -OrganizationID ''} | Should -Throw
        }
        It 'Returns no results when a gibberish NetworkID is specified' {
            Get-PSMAPINetwork -NetworkID 'qwertyqwertyqwerty' | Should -BeNullOrEmpty
        }
        It 'Returns no results when a gibberish OrganizationID is specified' {
            Get-PSMAPINetwork -OrganizationID 'qwertyqwertyqwerty' | Should -BeNullOrEmpty
        }
    }

    Context "Network object has the correct properties" {
        $netObject = Get-PSMAPINetwork -OrganizationID 549236 -Name 'DevNet Always On Read Only'

        # Load an array with the properties we need to look for
        $properties = ('id', 'organizationId', 'name', 'timeZone', 'tags', 'type', 'productTypes', 'disableMyMerakiCom')

        foreach ($property in $properties){
            It "Network object should have a property of $property" {
                [bool]($netObject.PSObject.Properties.Name -match $property) | Should -BeTrue
            }
        }

        It "Network object should not have a gibberish property" {
            [bool]($netObject.PSObject.Properties.Name -match 'qwertyqwertyqwerty') | Should -not -BeTrue
        }
    } # Context correct properties
}
