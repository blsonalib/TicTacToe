#!/bin/bash

echo "**********Welcome to TicTacToe Game**********"
# Constant

MAXIMUM_POSION_OF_BOARD=9
NUMBER_OF_CELLS=9

playerPosition=0
computerPosition=0
player=''
computer=''
EmptyBlockNotCount=1

winningCounter=false
whoPlays=false
computerWinMove=false
computerMoveBlocked=false

declare -A cellsOfTicTicTacToeGame


function resetTheBoardOfGame() {
        local count1=1;
	for (( cell=1; cell<=$NUMBER_OF_CELLS; cell++ ))
	do
		cellsOfTicTicTacToeGame[$cell]='-'
                
	done
}


function symbolsOfGame()
{
	symbols=$((RANDOM%2))

	if [ $symbols -eq 1 ]
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
	read -p "Enter  position number put player at Empty Position " playerPosition
	if [[ ${cellsOfTicTicTacToeGame[$playerPosition]} == '-' ]]
	then
		cellsOfTicTicTacToeGame[$playerPosition]=$player
	else
		echo ":Position Occupied Please enter new Position"
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
	winBlockPlayMove $computer
	winBlockPlayMove $player
	checkInCorners
        checkForMiddles 
	if [ $computerWinMove = false ]
	then

		computerPosition=$((RANDOM%9+1))
		if [[ ${cellsOfTicTicTacToeGame[$computerPosition]} != '-' ]]
		then
			computerTurn
		else
			cellsOfTicTicTacToeGame[$computerPosition]=$computer
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
			if [[ ${cellsOfTicTicTacToeGame[$counter]} == ${cellsOfTicTicTacToeGame[$counter+$1+$1]} ]] && [[ ${cellsOfTicTicTacToeGame[$counter+$1]} == '-' ]] && [[ ${cellsOfTicTicTacToeGame[$counter]} == $symbol ]]
			then
				computerPosition=$(($counter+$1))
				cellsOfTicTicTacToeGame[$computerPosition]=$computer
				computerWinMove=true
				break
			elif [[  ${cellsOfTicTicTacToeGame[$counter]} == ${cellsOfTicTicTacToeGame[$counter+$1]} ]] && [[  ${cellsOfTicTicTacToeGame[$counter+$1+$1]} == '-' ]] && [[ ${cellsOfTicTicTacToeGame[$counter]} == $symbol ]]
			then
				computerPosition=$(($counter+$1+$1))
				cellsOfTicTicTacToeGame[$computerPosition]=$computer
				computerWinMove=true
				break
			elif [[ ${cellsOfTicTicTacToeGame[$counter+$1]} == ${cellsOfTicTicTacToeGame[$counter+$1+$1]} ]] && [[ ${cellsOfTicTicTacToeGame[$counter]} == '-' ]] && [[ ${cellsOfTicTicTacToeGame[$counter+$1]} == $symbol ]]
			then
				computerPosition=$counter
				cellsOfTicTicTacToeGame[$computerPosition]=$computer
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
		for((i=1; i<=MAXIMUM_POSION_OF_BOARD; i=$(($i+2)) ))
		do
				if [ ${cellsOfTicTicTacToeGame[$i]} == '-' ]
				then
					computerPosition=$i
            	cellsOfTicTicTacToeGame[$computerPosition]=$computer
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
		for((i=1; i<=MAXIMUM_POSION_OF_BOARD; i=$(($i+2)) ))
		do
				if [ ${cellsOfTicTicTacToeGame[$i]} == '-' ]
				then
					computerPosition=$i
            	cellsOfTicTicTacToeGame[$computerPosition]=$computer
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
		if [[ ${cellsOfTicTicTacToeGame[$position]} == ${cellsOfTicTicTacToeGame[$position+$3]} ]] && [[  ${cellsOfTicTicTacToeGame[$position+$3]}  ==  ${cellsOfTicTicTacToeGame[$position+$3+$3]} ]] && [[ ${cellsOfTicTicTacToeGame[$position+$3+$3]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			winningCounter=true
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
		if [[ ${cellsOfTicTicTacToeGame[$position]} == ${cellsOfTicTicTacToeGame[$position+4]} ]] && [[  ${cellsOfTicTicTacToeGame[$position+4]}  ==  ${cellsOfTicTicTacToeGame[$position+8]} ]] && [[ ${cellsOfTicTicTacToeGame[$position+8]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			winningCounter=true
			break
		elif [[ ${cellsOfTicTicTacToeGame[$position+2]} == ${cellsOfTicTicTacToeGame[$position+4]} ]] && [[  ${cellsOfTicTicTacToeGame[$position+4]}  ==  ${cellsOfTicTicTacToeGame[$position+6]} ]] && [[ ${cellsOfTicTicTacToeGame[$position+6]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			winningCounter=true
			break
		fi
		temporary=$(($temporary+1))
	done
}


function checkGameTie()
{
	while [ ${cellsOfTicTicTacToeGame[$EmptyBlockNotCount]} != '-' ]
	do
		if [ $EmptyBlockNotCount -eq $MAXIMUM_POSION_OF_BOARD ]
		then
			printBoard
			echo "Game Is Tie"
			winningCounter=true
			computerWinMove=true
			break
		else
			EmptyBlockNotCount=$(($EmptyBlockNotCount+1))
		fi
	done
}



function checkwinningCounter()
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
 while [ $winningCounter == false ]
 do
	printBoard
	if [ $whoPlays == true ]
	then
		playerTurn
		checkwinningCounter $player
		checkGameTie
	else
		computerTurn
		checkwinningCounter $computer
		checkGameTie
	fi

 done
}
function checkForMiddles()
{
	if [ $computerWinMove = false ]
   then
            if [ ${cellsOfTicTicTacToeGame[$counter]} == '-' ]
            then
               computerPosition=$(($counter+4))
               cellsOfTicTicTacToeGame[$computerPosition]=$computer
               computerWinMove=true
            break
            fi
      
   fi

}

function printBoard()
{
   echo "    |---|---|---|"
   echo "    | "${cellsOfTicTicTacToeGame[1]}" | "${cellsOfTicTicTacToeGame[2]}" | "${cellsOfTicTicTacToeGame[3]}" |"
   echo "    |---|---|---|"
   echo "    | "${cellsOfTicTicTacToeGame[4]}" | "${cellsOfTicTicTacToeGame[5]}" | "${cellsOfTicTicTacToeGame[6]}" |"
   echo "    |---|---|---|"
   echo "    | "${cellsOfTicTicTacToeGame[7]}" | "${cellsOfTicTicTacToeGame[8]}" | "${cellsOfTicTicTacToeGame[9]}" |"
   echo "    |---|---|---|"

}

resetTheBoardOfGame
symbolsOfGame
playGame

