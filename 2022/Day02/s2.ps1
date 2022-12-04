[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Path = '.\sample.txt'
    )
    
$rock = 'A'
$paper = 'B'
$scissors = 'C'

$round_lose = 'X'
$round_draw = 'Y'
$round_win = 'Z'

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
        $rock { 'Rock' }
        $paper { 'Paper' }
        $scissors { 'Scissors' }
        Default { Write-Error 'Failed'}
    }
}


function Get-PlayedScore ($letter) {
    switch ($letter) {
        $rock { $rock_score }
        $paper { $paper_score }
        $scissors { $scissors_score }
        Default {Write-Error 'Failed'}
    }
}

function Get-Outcome ($letter) {
    switch ($letter) {
        $round_lose { 'lose' }
        $round_draw { 'draw' }
        $round_win { 'win' }
        Default { Write-Error 'Failed' }
    }
}
function ConvertTo-MyGame ($p1, $me) {
    $l = Get-Outcome $me
    $p1_original = $p1.Clone()
    $p1 = ConvertTo-Game $p1

    if ($l -eq 'draw') {
        $p1_original
    }
    elseif ($p1 -eq 'Rock' -and $l -eq 'lose') {
        $scissors
    }
    elseif ($p1 -eq 'Rock' -and $l -eq 'win') {
        $paper
    }
    elseif ($p1 -eq 'Paper' -and $l -eq 'lose') {
        $rock
    }
    elseif ($p1 -eq 'Paper' -and $l -eq 'win') {
        $scissors
    }
    elseif ($p1 -eq 'Scissors' -and $l -eq 'lose') {
        $paper
    }
    elseif ($p1 -eq 'Scissors' -and $l -eq 'win') {
        $rock
    }
    else{
        'Failure'
    }
}

[int]$myscore = 0
$games = gc $Path

foreach ($g in $games) {
    $players = $g -split ' '
    $p1 = $players[0]
    $me = $players[1]
    $me = ConvertTo-MyGame $p1 $me

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
