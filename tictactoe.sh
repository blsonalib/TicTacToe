#!/bin/bash -x

# Constant

MAXIMUM_NUMBER_OF_POSITION=9
NUMBER_OF_CELLS=9

#variables
playerPosition=0
computerPosition=0
player=''
computer=''
EmptyBlockNotCount=1
winCount=false
whoPlays=false
computerWinningMovee=false
computerblockedMove=false
sizeOfBoard=3

declare -A cellsOfTicTacToeGame


function resetTheBoardOfGame() 
{
	local count1=1;
	for (( cell=1; cell<=$NUMBER_OF_CELLS; cell++ ))
	do
		cellsOfTicTacToeGame[$cell]='-'
                
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
		echo "Player plays First"
	else
		player='O'
		computer='X'
		echo "Computer Plays First"
	fi
}



function playerMove()
{
	read -p "Enter the position 0-9 : " playerPosition
	if [ ${cellsOfTicTacToeGame[$playerPosition]} == '-' ]
	then
		cellsOfTicTacToeGame[$playerPosition]=$player
	else  
                echo "       Enter Again      "
		playerMove
	fi
	whoPlays=false
}

function winBlockPlayMove()
{
	rowValue=1
	columnValue=3
	leftDiagonalValue=4
	rightDiagonalValue=2

	checkWinningMove $rowValue $columnValue $1
	checkWinningMove $columnValue $rowValue $1
	checkWinningMove $leftDiagonalValue 0 $1
	checkWinningMove $rightDiagonalValue 0 $1

}

function computerMove()
{
	computerWinningMovee=false
	echo "Computer is playing"
        sleep 1
	winBlockPlayMove $computer
	winBlockPlayMove $player
	checkEmptyCornersInBoard
        checkTheSides 
	if [ $computerWinningMovee = false ]
	then

		computerPosition=$((RANDOM%9+1))
		if [[ ${cellsOfTicTacToeGame[$computerPosition]} != '-' ]]
		then
			computerMove
		else
			cellsOfTicTacToeGame[$computerPosition]=$computer
		fi
	fi
	whoPlays=true
}

function checkWinningMove()
{
	counter=1
	symbol=$3
	if [ $computerWinningMovee = false ]
	then
		for (( i=1; i<=$sizeOfBoard; i++ ))
		do
			if [[ ${cellsOfTicTacToeGame[$counter]} == ${cellsOfTicTacToeGame[$counter+$1+$1]} ]] && [[ ${cellsOfTicTacToeGame[$counter+$1]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$counter]} == $symbol ]]
			then
				computerPosition=$(($counter+$1))
				cellsOfTicTacToeGame[$computerPosition]=$computer
				computerWinningMovee=true
				break
			elif [[  ${cellsOfTicTacToeGame[$counter]} == ${cellsOfTicTacToeGame[$counter+$1]} ]] && [[  ${cellsOfTicTacToeGame[$counter+$1+$1]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$counter]} == $symbol ]]
			then
				computerPosition=$(($counter+$1+$1))
				cellsOfTicTacToeGame[$computerPosition]=$computer
				computerWinningMovee=true
				break
			elif [[ ${cellsOfTicTacToeGame[$counter+$1]} == ${cellsOfTicTacToeGame[$counter+$1+$1]} ]] && [[ ${cellsOfTicTacToeGame[$counter]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$counter+$1]} == $symbol ]]
			then
				computerPosition=$counter
				cellsOfTicTacToeGame[$computerPosition]=$computer
				computerWinningMovee=true
				break
			fi
			counter=$(($counter+$2))
		done
	fi
}

function checkEmptyCornersInBoard
{
	if [ $computerWinningMovee = false ]
	then
		for((counter=1; counter<=MAXIMUM_NUMBER_OF_POSITION; counter=$(($counter+2)) ))
		do
			if [ ${cellsOfTicTacToeGame[$counter]} == '-' ]
			then
				computerPosition=$counter
            			cellsOfTicTacToeGame[$computerPosition]=$computer
            			computerWinningMovee=true
           			break
			fi
			if [ $counter -eq $sizeOfBoard ]
			then
				counter=$(($counter+2))
				fi
		done
	fi
}



function winInRowsAndColumns()
{
	position=1
	temp=1
	while [  $temp -le $sizeOfBoard ]
	do
		if [[ ${cellsOfTicTacToeGame[$position]} == ${cellsOfTicTacToeGame[$position+$3]} ]] && [[  ${cellsOfTicTacToeGame[$position+$3]}  ==  ${cellsOfTicTacToeGame[$position+$3+$3]} ]] && [[ ${cellsOfTicTacToeGame[$position+$3+$3]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			winCount=true
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
			winCount=true
			break
		elif [[ ${cellsOfTicTacToeGame[$position+2]} == ${cellsOfTicTacToeGame[$position+4]} ]] && [[  ${cellsOfTicTacToeGame[$position+4]}  ==  ${cellsOfTicTacToeGame[$position+6]} ]] && [[ ${cellsOfTicTacToeGame[$position+6]} == $1 ]]
		then
			printBoard
			echo "$1 wins "
			winCount=true
			break
		fi
		temp=$(($temp+1))
	done
}


function checkGameTieUp()
{
	while [ ${cellsOfTicTacToeGame[$EmptyBlockNotCount]} != '-' ]
	do
		if [ $EmptyBlockNotCount -eq $MAXIMUM_NUMBER_OF_POSITION ]
		then
			printBoard
			echo "Tie Up"
			winCount=true
			computerWinningMovee=true
			break
		else
			EmptyBlockNotCount=$(($EmptyBlockNotCount+1))
		fi
	done
}



function checkCountWin()
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
	while [ $winCount == false ]
	do
		printBoard
		if [ $whoPlays == true ]
		then
			playerMove
			checkCountWin $player
			checkGameTieUp
		else
			computerMove
			checkCountWin $computer
			checkGameTieUp
		fi

done
}
function checkTheSides()
{
	if [ $computerWinningMovee = false ]
	then
		for (( counter=2; counter<=$(($MAXIMUM_NUMBER_OF_POSITION-1)); counter=$(($counter+2)) ))
		do
			if [[ ${cellsOfTicTacToeGame[$counter]} == '-' ]]
			then
		  		computerPosition=$counter
        			cellsOfTicTacToeGame[$computerPosition]=$computer
        			computerWinningMovee=true
        			break
 			fi
 			if [[ $counter -eq $(($MAXIMUM_NUMBER_OF_POSITION-1)) ]] && [[ $computerWinningMovee = false ]] && [[ ${cellsOfTicTacToeGame[$counter]} == '-' ]]
 			then
      				computerPosition=$counter
      				cellsOfTicTacToeGame[$computerPosition]=$computer
      				computerWinningMovee=true
 			fi
		done
	fi

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
