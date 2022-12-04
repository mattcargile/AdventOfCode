[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Path = '.\sample.txt'
    )
    
$rock = 'A','X'
$paper = 'B','Y'
$scissors = 'C','Z'

$rock_score = 1
$paper_score = 2
$scissors_score = 3

$lost_score = 0
$draw_score = 3
$win_score = 6

<# 
# Rock -> Scissors
# Paper -> Rock
# Scissors -> Paper
#>
function Get-Winner ( [ValidateSet('Rock','Paper','Scissors')]$p1,[ValidateSet('Rock','Paper','Scissors')]$p2) {
    if ($p1 -eq $p2) {
        'draw'
    }
    elseif ($p1 -eq 'Rock' -and $p2 -eq 'Paper' ) {
        'p2'
    }
    elseif ($p1 -eq 'Paper' -and $p2 -eq 'Rock') {
        'p1'
    }
    elseif ($p1 -eq 'Rock' -and $p2 -eq 'Scissors') {
        'p1'
    }
    elseif ($p1 -eq 'Scissors' -and $p2 -eq 'Rock') {
        'p2'
    }
    elseif ($p1 -eq 'Paper' -and $p2 -eq 'Scissors') {
        'p2'
    }
    elseif ($p1 -eq 'Scissors' -and $p2 -eq 'Paper') {
        'p1'
    }
    else {
        Write-Error 'Something went wrong'
    }
}

function ConvertTo-Game ($letter) {
    switch ($letter) {
        { $_ -in $rock } { 'Rock' }
        { $_ -in $paper } { 'Paper' }
        { $_ -in $scissors } { 'Scissors' }
        Default {'Failure'}
    }
}

function Get-PlayedScore ($letter) {
    switch ($letter) {
        { $_ -in $rock } { $rock_score }
        { $_ -in $paper } { $paper_score }
        { $_ -in $scissors } { $scissors_score }
        Default {0}
    }
}

[int]$myscore = 0
$games = gc $Path

foreach ($g in $games) {
    $players = $g -split ' '
    $p1 = $players[0]
    $me = $players[1]

    # map input    
    $win = Get-Winner (ConvertTo-Game $p1) ( ConvertTo-Game $me )

    # calc score
    if ($win -eq 'draw') {
        $myscore += $draw_score
        $myscore += Get-PlayedScore $me
    }
    elseif ( $win -eq 'p1') {
        $myscore += $lost_score
        $myscore += Get-PlayedScore $me
    }
    elseif ( $win -eq 'p2') {
        $myscore += $win_score
        $myscore += Get-PlayedScore $me
    }
    
}

Write-Output $myscore
