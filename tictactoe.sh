#!/bin/bash -x
echo "**********Welcome to TicTacToe Game**********"
# Constant
NUMBER_OF_CELLS=9
#variables
playerPosition=0
computerPosition=0
player=''
computer=''
emtyBoardNotCount=1

wincount=false
whoPlays=false
computerWinMove=false
computerblockedMove=false

#disctionary

declare -A cellsOfTicTacToeGame

function resetTheBoardOfGame() {

        local count1=1;
	for (( cell=1; cell<=$NUMBER_OF_CELLS; cell++ ))
	do
		cellsOfTicTacToeGame[$cell]='-'
                
	done
}


function symbolOfGame()
{
	symbol=$((RANDOM%2))

	if [ $symbol -eq 1 ]
	then
		whoPlays=true
		player='X'
		computer='O'
		echo "Player play First"
	else
		player='O'
		computer='X'
		echo "Computer Play First"
	fi
}



function player()
{
	read -p "Enter  position Number of position:" playerPosition
	if [ ${cellsOfTicTacToeGame[$playerPosition]} == '-' ]
	then
		cellsOfTicTacToeGame[$playerPosition]=$player
	else
		
		player
	fi
	whoPlays=false
}

function winBlockPlayMove()
{
	rowValue=1
	columnValue=3
	leftDiagonalValue=4
	rightDiagonalValue=2

	checkWinMove $rowValue $1 $columnValue
	checkWinMove $columnValue $1 $rowValue
	checkWinMove $leftDiagonalValue $1 0
	checkWinMove $rightDiagonalValue $1 0

}

function computerTurn()
{
	computerWinMove=false
	echo "Computer is playing"
	winBlockPlayMove $computer
	winBlockPlayMove $player
	checkInCorners
	if [ $computerWinMove = false ]
	then

		computerPosition=$((RANDOM%9+1))
		if [[ ${cellsOfTicTacToeGame[$computerPosition]} != '-' ]]
		then
			computerTurn
		else
			cellsOfTicTacToeGame[$computerPosition]=$computer
		fi
	fi
	whoPlays=true
}

function checkWinMove()
{
	count=1
	symbol=$2
	if [ $computerWinMove = false ]
	then
		for (( i=1; i<=3; i++ ))
		do
			if [[ ${cellsOfTicTacToeGame[$count]} == ${cellsOfTicTacToeGame[$count+$1+$1]} ]] && [[ ${cellsOfTicTacToeGame[$count+$1]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$count]} == $symbol ]]
			then
				computerPosition=$(($count+$1))
				cellsOfTicTacToeGame[$computerPosition]=$computer
				computerWinMove=true
				break
			elif [[  ${cellsOfTicTacToeGame[$count]} == ${cellsOfTicTacToeGame[$count+$1]} ]] && [[  ${cellsOfTicTacToeGame[$count+$1+$1]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$count]} == $symbol ]]
			then
				computerPosition=$(($count+$1+$1))
				cellsOfTicTacToeGame[$computerPosition]=$computer
				computerWinMove=true
				break
			elif [[ ${cellsOfTicTacToeGame[$count+$1]} == ${cellsOfTicTacToeGame[$count+$1+$1]} ]] && [[ ${cellsOfTicTacToeGame[$count]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$count+$1]} == $symbol ]]
			then
				computerPosition=$count
				cellsOfTicTacToeGame[$computerPosition]=$computer
				computerWinMove=true
				break
			fi
			count=$(($count+$3))
		done
	fi
}


function checkInCorners
{
	 if [ $computerWinMove = false ]
   then
		for((i=1; i<=MAX_BOARD_POSITION; i=$(($i+2)) ))
		do
				if [ ${cellsOfTicTacToeGame[$i]} == '-' ]
				then
					computerPosition=$i
            	cellsOfTicTacToeGame[$computerPosition]=$computer
            	computerWinMove=true
            break
				fi
				if [ $i -eq 3 ]
				then
					i=$(($i+2))
				fi
		done
	fi
}



function winInRowsAndColumns()
{
	position=1
	temporary=1
	while [  $temporary -le 3 ]
	do
		if [[ ${cellsOfTicTacToeGame[$position]} == ${cellsOfTicTacToeGame[$position+$3]} ]] && [[  ${cellsOfTicTacToeGame[$position+$3]}  ==  ${cellsOfTicTacToeGame[$position+$3+$3]} ]] && [[ ${cellsOfTicTacToeGame[$position+$3+$3]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			wincount=true
			exit
			break
		else
			position=$(( $position+$2 ))
		fi
		temporary=$(($temporary+1))
	done
}




function winInDiagonals()
{
	position=1
	temporary=1
	while [ $temporary -le 2 ]
	do
		if [[ ${cellsOfTicTacToeGame[$position]} == ${cellsOfTicTacToeGame[$position+4]} ]] && [[  ${cellsOfTicTacToeGame[$position+4]}  ==  ${cellsOfTicTacToeGame[$position+8]} ]] && [[ ${cellsOfTicTacToeGame[$position+8]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			wincount=true
			break
		elif [[ ${cellsOfTicTacToeGame[$position+2]} == ${cellsOfTicTacToeGame[$position+4]} ]] && [[  ${cellsOfTicTacToeGame[$position+4]}  ==  ${cellsOfTicTacToeGame[$position+6]} ]] && [[ ${cellsOfTicTacToeGame[$position+6]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			wincount=true
			break
		fi
		temporary=$(($temporary+1))
	done
}


function checkGameToTieUp()
{
	while [ ${cellsOfTicTacToeGame[$emtyBoardNotCount]} != '-' ]
	do
		if [ $emtyBoardNotCount -eq $MAX_BOARD_POSITION ]
		then
			printBoard
			echo "Game Is Tie"
			wincount=true
			computerWinMove=true
			break
		else
			emtyBoardNotCount=$(($emtyBoardNotCount+1))
		fi
	done
}



function checkwincount()
{
	symbol=$1
	rowValue=1
	columnValue=3

	winInRowsAndColumns $symbol $columnValue  $rowValue
 	winInRowsAndColumns $symbol $rowValue $columnValue
	winInDiagonals $symbol
}

function playGame()
{
 while [ $wincount == false ]
 do
	printBoard
	if [ $whoPlays == true ]
	then
		player
		checkwincount $player
		checkGameToTieUp
	else
		computerTurn
		checkwincount $computer
		checkGameToTieUp
	fi

 done
}
function printBoard()
{
   echo "    |---|---|---|"
   echo "    | "${cellsOfTicTacToeGame[1]}" | "${cellsOfTicTacToeGame[2]}" | "${cellsOfTicTacToeGame[3]}" |"
   echo "    |---|---|---|"
   echo "    | "${cellsOfTicTacToeGame[4]}" | "${cellsOfTicTacToeGame[5]}" | "${cellsOfTicTacToeGame[6]}" |"
   echo "    |---|---|---|"
   echo "    | "${cellsOfTicTacToeGame[7]}" | "${cellsOfTicTacToeGame[8]}" | "${cellsOfTicTacToeGame[9]}" |"
   echo "    |---|---|---|"

}

resetTheBoardOfGame
symbolOfGame
playGame
