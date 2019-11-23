#!/bin/bash -x

# Constant

NUMBER_OF_CELLS=9

#variables

playerPosition=0
positionOfComputer=0
player=''
computer=''
winCount=false
computerMoveWin=false
computerMoveBlocked=false

#disctionary

declare -A cellsOfTicTacToeGame


function resetTheBoardOfGame() 
{
	for (( cell=1; cell<=$NUMBER_OF_CELLS; cell++ ))
	do
		cellsOfTicTacToeGame[$cell]="-"

	done
       
}           

function symbolsOfGame()
{
	symbols=$((RANDOM%2))

	if [[ $symbols == 0 ]]
	then
		whoIsPlays=true
		player='X'
		computer='O'
		echo "Player plays First"
	else
		player='O'
		computer='X'
		echo "Computer Plays First"
	fi
}

function playGame()
{
        while [ $winCount == false ]
        do
                printBoard
                if [[ $whoIsPlays == true ]]
                then
                        playerTurn
                        checkwinCount $player
                        CheckGameForTie
                else
                        computerTurn
                        checkwinCount $computer
                        CheckGameForTie
                fi

        done
}


function playerTurn()
{
        echo "player play"
        whoIsPlays=true
	read -p "Enter the position 0-9 : " playerPosition
	if [[ ${cellsOfTicTacToeGame[$playerPosition]} == '-' ]]
	then
		cellsOfTicTacToeGame[$playerPosition]=$player
               
	else  
                echo "Try Again"
		playerTurn
	fi
	        whoIsPlays=false
}

function computerTurn()
{
        echo "Computer play"
        computerMoveWin=false
        ToCheckTheCornerIsEmpty
        checkTheSides 
        if [[ $computerMoveWin = false ]]
        then

                positionOfComputer=$((RANDOM%9+1))
                if [[ ${cellsOfTicTacToeGame[$positionOfComputer]} != '-' ]]
                then
                        computerTurn
                else
                        cellsOfTicTacToeGame[$positionOfComputer]=$computer
                fi
        fi
                       whoIsPlays=true
}

function ToCheckWinningMove()
{
	counter=1
	if [ $computerMoveWin = false ]
	then
		for (( i=1; i<=$sizeOfTheBoard; i++ ))
		do
			if [[ ${cellsOfTicTacToeGame[$counter]} == ${cellsOfTicTacToeGame[$counter+$1+$1]} ]] && [[ ${cellsOfTicTacToeGame[$counter+$1]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$counter]} == $symbols ]]
			then
				positionOfComputer=$(($counter+$1))
				cellsOfTicTacToeGame[$positionOfComputer]=$computer
				computerMoveWin=true
				break
			     elif [[  ${cellsOfTicTacToeGame[$counter]} == ${cellsOfTicTacToeGame[$counter+$1]} ]] && [[  ${cellsOfTicTacToeGame[$counter+$1+$1]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$counter]} == $symbols ]]
			     then
					positionOfComputer=$(($counter+$1+$1))
					cellsOfTicTacToeGame[$positionOfComputer]=$computer
					computerMoveWin=true
					break
				elif [[ ${cellsOfTicTacToeGame[$counter+$1]} == ${cellsOfTicTacToeGame[$counter+$1+$1]} ]] && [[ ${cellsOfTicTacToeGame[$counter]} == '-' ]] && [[ ${cellsOfTicTacToeGame[$counter+$1]} == $symbol ]]
				then
					positionOfComputer=$counter
					cellsOfTicTacToeGame[$positionOfComputer]=$computer
					computerMoveWin=true
					break
			fi
	                 		counter=$(($counter+$1))
		done
	fi
}

function ToCheckTheCornerIsEmpty
{
	if [[ $computerMoveWin = false ]]
	then
		for ((counter=1; counter<=$NUMBER_OF_CELLS; counter=$(($counter+1)) ))
		do
			if [[ ${cellsOfTicTacToeGame[$counter]} == '-' ]]
			then
				positionOfComputer=$counter
            			cellsOfTicTacToeGame[$positionOfComputer]=$computer
            			computerMoveWin=true
           			break
			fi
			if [[ $counter == $sizeOfTheBoard ]]
			then
				counter=$(($counter+2))
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

function winRowAndColumns()
{      
        local sizeOfTheBoard=3
	position=1
	count1=1
	while [  $count1 -le $sizeOfTheBoard ]
	do
		if [[ ${cellsOfTicTacToeGame[$position]} == ${cellsOfTicTacToeGame[$position+$3]} ]] && [[  ${cellsOfTicTacToeGame[$position+$3]}  ==  ${cellsOfTicTacToeGame[$position+$3+$3]} ]] && [[ ${cellsOfTicTacToeGame[$position+$3+$3]} == $1 ]]
		then
			printBoard
			echo "player wins "
			winCount=true
			exit
			break
		else
			position=$(( $position+$2 ))
		fi
		count1=$(($count1+1))
	done
}


function WinInDiagonal()
{
	position=1
	count1=1
        diagonalCells=2
	while [ $count1 -le $diagonalCells ]
	do
		if [[ ${cellsOfTicTacToeGame[$position]} == ${cellsOfTicTacToeGame[$position+4]} ]] && [[  ${cellsOfTicTacToeGame[$position+4]}  ==  ${cellsOfTicTacToeGame[$position+8]} ]] && [[ ${cellsOfTicTacToeGame[$position+8]} == $1 ]]
		then
			printBoard
			winCount=true
			break
		elif [[ ${cellsOfTicTacToeGame[$position+2]} == ${cellsOfTicTacToeGame[$position+4]} ]] && [[  ${cellsOfTicTacToeGame[$position+4]}  ==  ${cellsOfTicTacToeGame[$position+6]} ]] && [[ ${cellsOfTicTacToeGame[$position+6]} == $1 ]]
		then
			printBoard
			winCount=true
			break
		fi
			count1=$(($count1+1))
	done
}


function CheckGameForTie()
{
        local nonEmptyBlockCount=1
	while [ ${cellsOfTicTacToeGame[$nonEmptyBlockCount]} != '-' ]
	do
		if [[ $nonEmptyBlockCount == $NUMBER_OF_CELLS ]]
		then
			printBoard
			winCount=true
			computerMoveWin=true
                        echo "Tie Up"
			break
		else
			nonEmptyBlockCount=$(($nonEmptyBlockCount+1))
                        
		fi
	done
}

function checkwinCount()
{
	symbols=$1
	rowValue=1
	columnValue=3

	winRowAndColumns $symbols $columnValue  $rowValue
 	winRowAndColumns $symbols $rowValue $columnValue
	WinInDiagonal $symbols
}

function checkTheSides()
{
	if [ $computerMoveWin = false ]
	then
		for (( counter=2; counter<=$(($NUMBER_OF_CELLS-1)); counter=$(($counter+2)) ))
		do
			if [[ ${cellsOfTicTacToeGame[$counter]} == '-' ]]
			then
		  		positionOfComputer=$counter
        			cellsOfTicTacToeGame[$positionOfComputer]=$computer
        			computerMoveWin=true
        			break
 			fi
 			if [[ $counter -eq $(($NUMBER_OF_CELLS-1)) ]] && [[ $computerMoveWin = false ]] && [[ ${cellsOfTicTacToeGame[$counter]} == '-' ]]
 			then
      				positionOfComputer=$counter
      				cellsOfTicTacToeGame[$positionOfComputer]=$computer
      				computerMoveWin=true
 			fi
		done
	fi

}
resetTheBoardOfGame
symbolsOfGame
playGame
