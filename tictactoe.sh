#!/bin/bash -x

#canstants
NUMBER_OF_CELLS=9

#variables
player=1x;
computer=0;
wincount=false;

#disctionary
declare -a cellsOfTicTacToeGame

function resetTheBoardOfGame()
{
 	count=1
	 for (( cell=1; cell<=$NUMBER_OF_CELLS; cell++ ))
	 do 
  		 cellsOfTicTacToeGame["$cell"]="$count";
  		 count=$(($count+1))
	 done
	 printBoard
}

function symbolOfGame()
{
	 resetTheBoardOfGame
	 whoPlayFirst $optionForToss
	 if [ $optionForToss -eq 1 ]
	 then 
   		  player=O;
    		  computer=X;
    		  checkTheWinner
	 else  
    		 player=X;
    		 computer=O;
    		 checkTheWinner  
	 fi
	 echo $optionForToss
}    
function whoPlayFirst()
{
	 optionForToss=$((RANDOM%2))
	 if [ $optionForToss -eq 0 ] 
	 then 
    		 echo "Player play First"
 	 else
    		 echo "Computer play First"
	 fi
}

function playGame()
{
     
   	  read -p "Enter the Position Computer Show Your Skills: " position
    	 if [ $position -le $NUMBER_OF_CELLS ] && [ $position -ne 0 ]
    	 then
               if  [ ${cellsOfTicTacToeGame["$position"]} = "$player" ] || [ ${cellsOfTicTacToeGame["position"]} = "$computer" ]
               then 
               	     
                    playGame $optionForToss
             	    printBoard
                else 
               	   if [ $optionForToss -eq 1 ]
            	  then 
                	  cellsOfTicTacToeGame[$position]=$computer
                  	  optionForToss=0;
                 	  printBoard
            		  elif [[ $optionForToss -eq 0 ]]
             		 then 
                 		 cellsOfTicTacToeGame[$position]=$player
                 		 optionForToss=1;
                 		 printBoard
             	     fi   
        	  fi
             fi
}
function checkTheWinner()
{
 	local count=0; 
 	while [ $( winInRows $wincount ) == false ] || [ $( winInColumns $wincount ) == false ] || [ $( winInDiagonals $wincount ) == false ] 
 	do 
   		count=$(($count + 1 ))
  		 playGame 
   		 winInRows $wincount
  
  		 winInColumns $wincount 
  		 winInDiagonals $wincount
  		 if [ $count -ge $NUMBER_OF_CELLS ]
  		 then 
       			 echo  Tie Up
      			 break
  		 fi 
                    echo "Stopped Game"
	 done 
}
function winInRows()
{
  	 local count=1;
   	 row=3
  	 for (( i=1; i<=$row; i++ ))
 	  do 
    	      if [ $optionForToss -eq 1 ]
    	      then  
       		  if [ "${cellsOfTicTacToeGame[$(($count))]}" = "${cellsOfTicTacToeGame[$(($count+1))]}" ] && [ "${cellsOfTicTacToeGame[$(($count+1))]}" = "${cellsOfTicTacToeGame[$(($count+2))]}" ] && [ "${cellsOfTicTacToeGame[$(($count))]}" = "$player" ]

        	 then 
            		 wincount=true
             		echo Player Win
            		 break 
        	  else
            		count=$((count+3))
                   fi
    	      else 
        	    if  [ "${cellsOfTicTacToeGame[$(($count))]}" = "${cellsOfTicTacToeGame[$(($count+1))]}" ] && [ "${cellsOfTicTacToeGame[$(($count))]}" = "${cellsOfTicTacToeGame[$(($count+2))]}" ] && [ "${cellsOfTicTacToeGame[$(($count))]}" = "$computer" ]
        	    then 
            		 wincount=true;
            		 echo Computer Win
            		 break
        	    else
            		 count=$((count+3))
         	     fi
               fi
  
          done
	  echo $wincount
}
function winInColumns()
{
  	column=3
 	for (( i=1; i<=$column; i++ ))
	 do 
   	  if [ $optionForToss -eq 1 ]
           then 
      		 if [ "${cellsOfTicTacToeGame[$((i))]}" = "${cellsOfTicTacToeGame[$(($i+3))]}" ] && [ "${cellsOfTicTacToeGame[$(($i))]}" = "${cellsOfTicTacToeGame[$(($i+6))]}" ] && [ "${cellsOfTicTacToeGame[$(($i+3))]}" = "$player" ]
      		 then 
          		 wincount=true
          		 echo You Win 
          		 break
     		  fi
  	 else
	       if [ "${cellsOfTicTacToeGame[$i]}" = "${cellsOfTicTacToeGame[$(($i+3))]}" ] && [ "${cellsOfTicTacToeGame[$i]}" = "${cellsOfTicTacToeGame[$(($i+6))]}" ] && [ "${cellsOfTicTacToeGame[$(($i+3))]}" = "$computer" ]
               then 
          	    wincount=true
           	    echo Computer Win
          	    break
      	        fi

           fi 
        done
        echo $wincount
}
function winInDiagonals()
{
  	 local count=1;
         diagonalCell=3
   	 for (( i=1; i<=$diagonalCell; i++ ))
         do 
    		 if [ $optionForToss -eq 1 ]
    		 then   
        		 if [ "${cellsOfTicTacToeGame[$count]}" = "${cellsOfTicTacToeGame[$(($count+4))]}" ] && [ "${cellsOfTicTacToeGame[$(($count+4))]}" = "${cellsOfTicTacToeGame[$((count+8))]}" ] && [ "${cellsOfTicTacToeGame[$(($count+8))]}" = "$player" ] 
                         then 
           			wincount=true
           			echo You Win
          			 break 
        			 elif [ "${cellsOfTicTacToeGame[$(($count+2))]}" = "${cellsOfTicTacToeGame[$(($count+4))]}" ] && [ "${cellsOfTicTacToeGame[$(($count+2))]}" = "${cellsOfTicTacToeGame[$(($count+6))]}" ] && [ "${cellsOfTicTacToeGame[$(($count+6))]}" = "$player" ] 
        			 then
             			wincount=true
             			echo You Win
             			break
        		 fi
   		 else   
		        if [ "${cellsOfTicTacToeGame[$count]}" = "${cellsOfTicTacToeGame[$(($count+4))]}" ] && [ "${cellsOfTicTacToeGame[$(($count+4))]}" = "${cellsOfTicTacToeGame[$(($count+8))]}" ] && [ "$cellsOfTicTacToeGame[$(($count+8))]" = "$computer" ] 
       			 then 
            			wincount=true
            			echo Computer Win
           			 break  
       				 elif [ "${cellsOfTicTacToeGame[$(($count+2))]}" = "${cellsOfTicTacToeGame[$(($count+4))]}" ] && [ "${cellsOfTicTacToeGame[$(($count+2))]}" = "${cellsOfTicTacToeGame[$(($count+6))]}" ] && [ "${cellsOfTicTacToeGame[$(($count+6))]}" = "$computer" ]
       				 then 
           			 wincount=true
            			echo Computer Win
           			break
      			 fi 
   		   fi
	 done
 	  echo $wincount
} 
function printBoard()
{
        echo "  |---|---|---|"
        echo "  |" ${cellsOfTicTacToeGame[1]}" | "${cellsOfTicTacToeGame[2]}" | "${cellsOfTicTacToeGame[3]} "| "
        echo "  |---|---|---|"
        echo "  | "${cellsOfTicTacToeGame[4]}" | "${cellsOfTicTacToeGame[5]}" | "${cellsOfTicTacToeGame[6]} "| "

        echo "  |---|---|---|"
        echo "  |" ${cellsOfTicTacToeGame[7]}" | "${cellsOfTicTacToeGame[8]}" | "${cellsOfTicTacToeGame[9]} "| "
        echo "  |---|---|---|"

}
symbolOfGame
