[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Path = '.\sample.txt'
)

$dt = gc $Path -Raw

($dt -split "`r`n`r`n|`r`r|`n`n") | 
    % { 
        ($_ -split "`n|`r`n|`r") | measure -sum
    } | measure Sum -Maximum | select -exp Maximum
