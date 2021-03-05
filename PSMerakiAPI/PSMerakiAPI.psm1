Write-Verbose "Importing PSMerakiAPI module functions from: $PSScriptRoot"
$Public = @( Get-ChildItem -Recurse -Path "$PSScriptRoot\Public\" -Filter *.ps1 )
$Private = @( Get-ChildItem -Recurse -Path "$PSScriptRoot\Private\" -Filter *.ps1 )

@($Public + $Private) | ForEach-Object {
    Try {
        . $_.FullName
    }
    Catch {
        Write-Error -Message "Failed to import function $($_.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName
