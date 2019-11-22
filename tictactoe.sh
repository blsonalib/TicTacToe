#!/bin/bash -x
echo "**********Welcome to TicTacToe Game**********"
# Constants
MAXIMUM_BOARD_POSITION =9
NUMBER_OF_CELLS=9

#variables
playerPosition=0
computerPosition=0
player=''
computer=''
emptyBlockNotCount=1

winCounter=false
whoPlays=false
computerWinMove=false
computerblockedMove=false

declare -A cellsOfTicTacToeGame


function resetTheBoardOfGame() {
        local count1=1;
	for (( cell=1; cell<=$NUMBER_OF_CELLS; cell++ ))
	do
		cellsOfTicTacToeGame[$cell]='-'
                
	done
}


function symbolsOfGame()
{
	result=$((RANDOM%2))

	if [ $result -eq 1 ]
	then
		whoPlays=true
		player='X'
		computer='O'
		echo "Player symobol : X | Computer symbol : O"
		echo "Player plays First"
	else
		player='O'
		computer='X'
		echo "Player symobol : O | Computer symbol : X"
		echo "Computer Plays First"
	fi
}



function playerTurn()
{
	read -p "Enter  position put the player : " playerPosition
	if [ ${cellsOfTicTacToeGame[$playerPosition]} == '-' ]
	then
		cellsOfTicTacToeGame[$playerPosition]=$player
	else

		playerTurn
	fi
	whoPlays=false
}

function winBlockPlayMove()
{
	rowValue=1
	columnValue=3
	leftDiagonalValue=4
	rightDiagonalValue=2

	checkWinningMove $rowValue $1 $columnValue
	checkWinningMove $columnValue $1 $rowValue
	checkWinningMove $leftDiagonalValue $1 0
	checkWinningMove $rightDiagonalValue $1 0

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

function checkWinningMove()
{
	counter=1
	symbol=$2
	if [ $computerWinMove = false ]
	then
		for (( i=1; i<=3; i++ ))
		do
			if [[ ${cellsOfTicTacToeGame[$counter]} == ${cellsOfTicTacToeGame[$counter+$1+$1]} ]] && [[ ${cellsOfTicTacToeGame[$counter+$1]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$counter]} == $symbol ]]
			then
				computerPosition=$(($counter+$1))
				cellsOfTicTacToeGame[$computerPosition]=$computer
				computerWinMove=true
				break
			elif [[  ${cellsOfTicTacToeGame[$counter]} == ${cellsOfTicTacToeGame[$counter+$1]} ]] && [[  ${cellsOfTicTacToeGame[$counter+$1+$1]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$counter]} == $symbol ]]
			then
				computerPosition=$(($counter+$1+$1))
				cellsOfTicTacToeGame[$computerPosition]=$computer
				computerWinMove=true
				break
			elif [[ ${cellsOfTicTacToeGame[$counter+$1]} == ${cellsOfTicTacToeGame[$counter+$1+$1]} ]] && [[ ${cellsOfTicTacToeGame[$counter]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$counter+$1]} == $symbol ]]
			then
				computerPosition=$counter
				cellsOfTicTacToeGame[$computerPosition]=$computer
				computerWinMove=true
				break
			fi
			counter=$(($counter+$3))
		done
	fi
}
function checkInCorners
{
	 if [ $computerWinMove = false ]
   then
		for((i=1; i<=MAXIMUM_BOARD_POSITION; i=$(($i+2)) ))
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

function checkInCorners
{
	 if [ $computerWinMove = false ]
   then
		for((i=1; i<=MAXIMUM_BOARD_POSITION; i=$(($i+2)) ))
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
	temp=1
	while [  $temp -le 3 ]
	do
		if [[ ${cellsOfTicTacToeGame[$position]} == ${cellsOfTicTacToeGame[$position+$3]} ]] && [[  ${cellsOfTicTacToeGame[$position+$3]}  ==  ${cellsOfTicTacToeGame[$position+$3+$3]} ]] && [[ ${cellsOfTicTacToeGame[$position+$3+$3]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			winCounter=true
			exit
			break
		else
			position=$(( $position+$2 ))
		fi
		temp=$(($temp+1))
	done
}




function winInDiagonals()
{
	position=1
	temp=1
	while [ $temp -le 2 ]
	do
		if [[ ${cellsOfTicTacToeGame[$position]} == ${cellsOfTicTacToeGame[$position+4]} ]] && [[  ${cellsOfTicTacToeGame[$position+4]}  ==  ${cellsOfTicTacToeGame[$position+8]} ]] && [[ ${cellsOfTicTacToeGame[$position+8]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			winCounter=true
			break
		elif [[ ${cellsOfTicTacToeGame[$position+2]} == ${cellsOfTicTacToeGame[$position+4]} ]] && [[  ${cellsOfTicTacToeGame[$position+4]}  ==  ${cellsOfTicTacToeGame[$position+6]} ]] && [[ ${cellsOfTicTacToeGame[$position+6]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			winCounter=true
			break
		fi
		temp=$(($temp+1))
	done
}


function checkGameTie()
{
	while [ ${cellsOfTicTacToeGame[$emptyBlockNotCount]} != '-' ]
	do
		if [[ $emptyBlockNotCount = $MAXIMUM_BOARD_POSITION ]]
		then
			printBoard
			echo "Tie Up"
			winCounter=true
			computerWinMove=true
			break
		else
			emptyBlockNotCount=$(($emptyBlockNotCount+1))
		fi
	done
}



function checkwinCounter()
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
 while [ $winCounter == false ]
 do
	printBoard
	if [ $whoPlays == true ]
	then
		playerTurn
		checkwinCounter $player
		checkGameTie
	else
		computerTurn
		checkwinCounter $computer
		checkGameTie
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
symbolsOfGame
playGame
