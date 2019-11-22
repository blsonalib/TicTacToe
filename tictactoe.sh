#!/bin/bash -x
# Constant

NUMBER_OF_POSITION=9

# variables
player=''
computer=''
winCounter=false
playerToSwitchs=false

declare -A cellsOfTicTacToeGame

function resetTheBoardOfGame() {

         local counter=1;
	 for (( cell=1; cell<=$NUMBER_OF_POSITION; cell++ ))
	 do
		cellsOfTicTacToeGame[$cell]=$counter
                counter=$(($counter+1))
	 done
}

function symbolOfGame() {
	 
        symbols=$(( RANDOM%2 ))
	if [ $symbols -eq 1 ]
	then
		player='X'
		computer='O'
	 else
		player='O'
		computer='X'
	  fi
}

function whoPlayFirst() {
       	 
         optionForToss=$(( RANDOM%2 ))
	 if [ $optionForToss -eq 0 ]
	  then
		 echo "Player will play first"
		 symbolOfGame 
                 printBoard
		 playerToSwitchs=false
                 
          else
		 echo "Computer will play first"
	       	 symbolOfGame
		 printBoard
		 playerToSwitchs=true
	   fi
}

function playerTurn() {

	echo "Player's Turn"
	read -p "Enter the positions between 1-9 to place cells : " positions
	if [[ $positions -le $NUMBER_OF_CELLS ]] && [[ $positions -ne 0 ]]
        then
            if [[ ${cellsOfTicTacToeGame["$positions"]} = $player ]] || [[ ${cellsOfTicTacToeGame["positions"]} = $computer ]]
            then
                 
                 playerTurn
                 printBoard
             else 
	         if [ $playerToSwitchs == false ]
		  then
		       	 cellsOfTicTacToeGame[$positions]=$player
		 fi
			 printBoard
              fi
	  fi
}

function computerTurn() {
	 
           echo "Computer's Turn"            
	   positionForComputer=$(( RANDOM%9 + 1 ))
           if  [[ ${cellsOfTicTacToeGame["$positionForComputer"]} == "$player" ]] || [[ ${cellsOfTicTacToeGame["positionForComputer"]} == "$computer" ]]
            
            then
                 symbolsOfGame
                 computerTurn
                 printBoard
            else 

		  cellsOfTicTacToeGame["$positionForComputer"]="$computer"
		  printBoard
            fi
      
}

function winInRowsAndColumns() {
	 
           startingPosition=1
           rowColumnCells=3
	   while [[ $startingPosition -le $rowColumnCells ]]
	   do
		if [[ ${cellsOfTicTacToeGame[$startingPosition]} == $1 ]] && [[ ${cellsOfTicTacToeGame[$startingPosition+$2]} == $1 ]] &&  [[ ${cellsOfTicTacToeGame[$startingPosition+$2+$2]} == $1 ]]
		then
			echo "$1 Winner"
			winCounter=true
			break
		else
			startingPosition=$(( $startingPosition + 3 ))
		fi
	    done
                       echo $winCounter
}

function winInDiagonals() {
	
             startingPosition=1
	     count=1
             diagonalCells=2 
	     while [ $count -le $diagonalCells ]
	     do
		 if [[ ${cellsOfTicTacToeGame[$startingPosition]} == $1 ]] && [[ ${cellsOfTicTacToeGame[$startingPosition + 4]} == $1 ]] &&  [[ ${cellsOfTicTacToeGame[$startingPosition+8]} == $1 ]]
		 then
			echo "$1 Winner"
			winCounter=true
			break
		       elif [[ ${cellsOfTicTacToeGame[$startingPosition + 2]} == $1 ]] && [[ ${cellsOfTicTacToeGame[$startingPosition + 4]} == $1 ]] &&  [ ${cellsOfTicTacToeGame[$startingPosition + 6]} == $1 ]]
		       then
			    echo "$1 Winner"
			    wintCounter=true
			    break
		   fi
	                   count=$(( $count + 1 ))
	      done
                         echo $winCounter
}

function playGame() 
{
        temporary=1;
	while [[ $( winInRowsAndColumns $winCounter ) == false ]] || [[ $( winInDiagonals $winCounter ) == false ]]
	do
               
		rowBlock=1
		columnBlock=3
	        if [[ $playerToSwitchs == false ]]
                then
                      playerTurn
                      winInRowsAndColumns $player $rowBlock  $winCounter
                      winInRowsAndColumns $player $columnBlock $rowBlock $winCounter
                      winInDiagonals $player $winCounter
                      if [[ $temporary -ge $NUMBER_OF_CELLS ]]
                      then
                         echo "Tie Up"
                         wintCounter=true
                         printBoard
                         break
                       fi
                          playerToSwitchs=true
      	             elif [[ $playerToSwitchs == true ]]
        	     then
               	         computerTurn
                         winInRowsAndColumns $computer $rowBlock $wintCounter
                         winInRowsAndColumns $computer $columnBlock $wintCounter
                         winInDiagonals $computer $wintCounter
                         if [[ $temporary -ge $NUMBER_OF_CELLS ]]
                         then
                             echo "Tie Up"
                             wintCounter=true
                             printBoard
                             break
                         fi 
                             playerToSwitchs=false
                    
                  fi
                          temporary=$(( $temporary + 1 ))
                
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
whoPlayFirst
