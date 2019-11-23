#!/bin/bash

echo "**********Welcome to TicTacToe Game**********"

#constant

NUMBER_OF_POSITION=9

#variables

positionOfPlayer=0
positionOfComputer=0
player=''
computer=''
emptyBlockNotCount=1
winningCount=false
whoPlays=false
computerWinMove=false
computerblockedMove=false
boardSize=3

#disctionary

declare -A boardOfTicTacToeGame


function resetTheBoardOfGame() 
{       
        count1=1
	for (( cell=1; cell<=$NUMBER_OF_POSITION; cell++ ))
	do
		boardOfTicTacToeGame[$cell]='-'
                
	done
}


function symbolsToDisplay()
{
	symbolResult=$((RANDOM%2))

	if [ $symbolResult -eq 1 ]
	then
		whoPlays=true
		player='X'
		computer='O'
		echo "Player plays First"
	else
		player='O'
		computer='X'
		echo "Computer Plays First"
	fi
}


function playerTurn()
{
	read -p "Enter the player position : " positionOfPlayer
	if [ ${boardOfTicTacToeGame[$positionOfPlayer]} == '-' ]
	then
		boardOfTicTacToeGame[$positionOfPlayer]=$player
	else
 
                echo " Try Again"
		playerTurn
	fi
	       whoPlays=false
}

function blockWinPlayMove()
{
	rowCount=1
	coloumnCount=3
	leftDiagonalCount=4
	rightDiagonalCount=2

	toCheckWinMove $rowCount $coloumnCount $1
	toCheckWinMove $coloumnCount $rowCount $1
	toCheckWinMove $leftDiagonalCount 0 $1
	toCheckWinMove $rightDiagonalCount 0 $1

}

function computerTurn()
{
	computerWinMove=false
	echo "Computer is playing"
        sleep 1
	blockWinPlayMove $computer
	blockWinPlayMove $player
	toCheckEmptyCorners
        toCheckSides 
	if [ $computerWinMove = false ]
	then

		positionOfComputer=$((RANDOM%9+1))
		if [[ ${boardOfTicTacToeGame[$positionOfComputer]} != '-' ]]
		then
			echo "move again"
			computerTurn
		else
			boardOfTicTacToeGame[$positionOfComputer]=$computer
		fi
	fi
	whoPlays=true
}

function toCheckWinMove()
{
	counter=1
	symbol=$3
	if [ $computerWinMove = false ]
	then
		for (( i=1; i<=$boardSize; i++ ))
		do
			if [[ ${boardOfTicTacToeGame[$counter]} == ${boardOfTicTacToeGame[$counter+$1+$1]} ]] && [[ ${boardOfTicTacToeGame[$counter+$1]} == '-' ]] && [[ ${boardOfTicTacToeGame[$counter]} == $symbol ]]
			then
				positionOfComputer=$(($counter+$1))
				boardOfTicTacToeGame[$positionOfComputer]=$computer
				computerWinMove=true
				break
			elif [[  ${boardOfTicTacToeGame[$counter]} == ${boardOfTicTacToeGame[$counter+$1]} ]] && [[  ${boardOfTicTacToeGame[$counter+$1+$1]} == '-' ]] && [[ ${boardOfTicTacToeGame[$counter]} == $symbol ]]
			then
				positionOfComputer=$(($counter+$1+$1))
				boardOfTicTacToeGame[$positionOfComputer]=$computer
				computerWinMove=true
				break
			elif [[ ${boardOfTicTacToeGame[$counter+$1]} == ${boardOfTicTacToeGame[$counter+$1+$1]} ]] && [[ ${boardOfTicTacToeGame[$counter]} == '-' ]] && [[ ${boardOfTicTacToeGame[$counter+$1]} == $symbol ]]
			then
				positionOfComputer=$counter
				boardOfTicTacToeGame[$positionOfComputer]=$computer
				computerWinMove=true
				break
			fi
			counter=$(($counter+$2))
		done
	fi
}

function toCheckEmptyCorners
{
	if [ $computerWinMove = false ]
	then
		for((counter=1; counter<=NUMBER_OF_POSITION; counter=$(($counter+2)) ))
		do
			if [ ${boardOfTicTacToeGame[$counter]} == '-' ]
			then
				positionOfComputer=$counter
            			boardOfTicTacToeGame[$positionOfComputer]=$computer
            			computerWinMove=true
           			break
			fi
			if [ $counter -eq $boardSize ]
			then
				counter=$(($counter+2))
				fi
		done
	fi
}



function winInRowsAndColumns()
{
	position=1
	counter=1
	while [  $counter -le $boardSize ]
	do
		if [[ ${boardOfTicTacToeGame[$position]} == ${boardOfTicTacToeGame[$position+$3]} ]] && [[  ${boardOfTicTacToeGame[$position+$3]}  ==  ${boardOfTicTacToeGame[$position+$3+$3]} ]] && [[ ${boardOfTicTacToeGame[$position+$3+$3]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			winningCount=true
			exit
			break
		else
			position=$(( $position+$2 ))
		fi
		counter=$(($counter+1))
	done
}




function winInDiagonals()
{
	position=1
	counter=1
	while [ $counter -le 2 ]
	do
		if [[ ${boardOfTicTacToeGame[$position]} == ${boardOfTicTacToeGame[$position+4]} ]] && [[  ${boardOfTicTacToeGame[$position+4]}  ==  ${boardOfTicTacToeGame[$position+8]} ]] && [[ ${boardOfTicTacToeGame[$position+8]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			winningCount=true
			break
		elif [[ ${boardOfTicTacToeGame[$position+2]} == ${boardOfTicTacToeGame[$position+4]} ]] && [[  ${boardOfTicTacToeGame[$position+4]}  ==  ${boardOfTicTacToeGame[$position+6]} ]] && [[ ${boardOfTicTacToeGame[$position+6]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			winningCount=true
			break
		fi
		counter=$(($counter+1))
	done
}


function checkIfGameTie()
{
	while [ ${boardOfTicTacToeGame[$emptyBlockNotCount]} != '-' ]
	do
		if [ $emptyBlockNotCount -eq $NUMBER_OF_POSITION ]
		then
			printBoard
			echo "Game Is Tie"
			winningCount=true
			computerWinMove=true
			break
		else
			emptyBlockNotCount=$(($emptyBlockNotCount+1))
		fi
	done
}



function checkwinningCount()
{
	symbol=$1
	rowCount=1
	coloumnCount=3

	winInRowsAndColumns $symbol $coloumnCount  $rowCount
 	winInRowsAndColumns $symbol $rowCount $coloumnCount
	winInDiagonals $symbol
}

function play()
{
	while [ $winningCount == false ]
	do
		printBoard
		if [ $whoPlays == true ]
		then
			playerTurn
			checkwinningCount $player
			checkIfGameTie
		else
			computerTurn
			checkwinningCount $computer
			checkIfGameTie
		fi

done
}
function toCheckSides()
{
	if [ $computerWinMove = false ]
	then
		for (( counter=2; counter<=$(($NUMBER_OF_POSITION-1)); counter=$(($counter+2)) ))
		do
			if [[ ${boardOfTicTacToeGame[$counter]} == '-' ]]
			then
		  		positionOfComputer=$counter
        			boardOfTicTacToeGame[$positionOfComputer]=$computer
        			computerWinMove=true
        			break
 			fi
 			if [[ $counter -eq $(($NUMBER_OF_POSITION-1)) ]] && [[ $computerWinMove = false ]] && [[ ${boardOfTicTacToeGame[$counter]} == '-' ]]
 			then
      				positionOfComputer=$counter
      				boardOfTicTacToeGame[$positionOfComputer]=$computer
      				computerWinMove=true
 			fi
		done
	fi

}

function printBoard()
{
      	
       echo "    |------------------------------|------------------------------|------------------------------|"
       echo "    | "${cellsOfTicTacToeGame[1]}" | "${cellsOfTicTacToeGame[2]}" | "${cellsOfTicTacToeGame[3]}" |"
       echo "    |------------------------------|------------------------------|------------------------------|"
       echo "    | "${cellsOfTicTacToeGame[4]}" | "${cellsOfTicTacToeGame[5]}" | "${cellsOfTicTacToeGame[6]}" |"
       echo "    |------------------------------|------------------------------|------------------------------|"
       echo "    | "${cellsOfTicTacToeGame[7]}" | "${cellsOfTicTacToeGame[8]}" | "${cellsOfTicTacToeGame[9]}" |"
       echo "    |------------------------------|------------------------------|------------------------------|"
}
resetTheBoardOfGame
symbolsToDisplay
play
