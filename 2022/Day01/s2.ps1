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
    } | sort Sum -Descending | select -first 3 | measure Sum -Sum | select -exp Sum
