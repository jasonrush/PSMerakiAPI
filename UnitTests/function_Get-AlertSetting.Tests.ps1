Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)/../PSMerakiAPI/PSMerakiAPI.psm1" -Prefix "PSMAPI"

$env:MerakiAPIKey = '093b24e85df15a3e66f1fc359f4c48493eaa1b73' # Demo Read-only API key

Describe 'Get-AlertSetting Tests' {
    Context 'Verify proper result counts' {
        It 'Returns one or more results when NetworkID is specified' {
            (Get-PSMAPIAlertSetting -NetworkID L_646829496481104079 | Measure-Object).count | Should -BeGreaterThan 0
        }
        It 'Throws an exception when a blank NetworkID is specified' {
            { Get-PSMAPIAlertSetting -NetworkID '' } | Should -Throw
        }
        It 'Returns no results when a gibberish NetworkID is specified' {
            Get-PSMAPIAlertSetting -NetworkID 'qwertyqwertyqwerty' | Should -BeNullOrEmpty
        }
    }

    Context "Alert configuration object has the correct properties" {
        $alertSettingObject = (Get-PSMAPIAlertSetting -NetworkID L_646829496481104079 | Select-Object -First 1)

        # Load an array with the properties we need to look for
        $properties = ('defaultDestinations', 'alerts')

        foreach ($property in $properties){
            It "Alert configuration object should have a property of $property" {
                [bool]($alertSettingObject.PSObject.Properties.Name -match $property) | Should -BeTrue
            }
        }

        It "Alert configuration object should not have a gibberish property" {
            [bool]($alertSettingObject.PSObject.Properties.Name -match 'qwertyqwertyqwerty') | Should -Not -BeTrue
        }
    } # Context correct properties
}
