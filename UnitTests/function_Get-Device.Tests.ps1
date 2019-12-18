Import-Module "$(Split-Path -parent $MyInvocation.MyCommand.Path)/../PSMerakiAPI/PSMerakiAPI.psm1" -Prefix "PSMAPI"

$env:MerakiAPIKey = '093b24e85df15a3e66f1fc359f4c48493eaa1b73' # Demo Read-only API key

Describe 'Get-Device Tests' {
    Context 'Verify proper result counts' {
        It 'Throws an exception with no parameters' {
            { Get-PSMAPIDevice } | Should -Throw
        }
        It 'Returns one or more results when OrganizationID is specified' {
            (Get-PSMAPIDevice -OrganizationID 549236).count | Should -BeGreaterThan 0
        }
        It 'Returns one or more results when NetworkID is specified' {
            (Get-PSMAPIDevice -NetworkID L_646829496481104156).count | Should -BeGreaterThan 0
        }
        It 'Throws an exception when a blank NetworkID is specified' {
            { Get-PSMAPIDevice -NetworkID '' } | Should -Throw
        }
        It 'Throws an exception when a blank OrganizationID is specified' {
            { Get-PSMAPIDevice -OrganizationID '' } | Should -Throw
        }
        It 'Returns no results when a gibberish NetworkID is specified' {
            Get-PSMAPIDevice -NetworkID 'qwertyqwertyqwerty' | Should -BeNullOrEmpty
        }
        It 'Returns no results when a gibberish OrganizationID is specified' {
            Get-PSMAPIDevice -OrganizationID 'qwertyqwertyqwerty' | Should -BeNullOrEmpty
        }
    }

    Context "Device object has the correct properties" {
        $devObject = (Get-PSMAPIDevice -NetworkID L_646829496481104156 | Select-Object -First 1)

        # Load an array with the properties we need to look for
        $properties = ('lat', 'lng', 'address', 'serial', 'mac', 'lanIp', 'networkId', 'model', 'firmware', 'floorPlanId')

        foreach ($property in $properties){
            It "Network object should have a property of $property" {
                [bool]($devObject.PSObject.Properties.Name -match $property) | Should -BeTrue
            }
        }

        It "Device object should not have a gibberish property" {
            [bool]($devObject.PSObject.Properties.Name -match 'qwertyqwertyqwerty') | Should -not -BeTrue
        }
    } # Context correct properties
}
