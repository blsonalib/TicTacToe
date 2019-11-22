#!/bin/bash -x
echo "**********Welcome to TicTacToe Game**********"
#canstants
PLAYER="X"
COMPUTER="O"

declare -A boardOfTicTacToeGame

function resetTheBoardOfGame()
{ 
    numberOfBlocks=9 
    for (( board=1; board<=numberOfBlocks ; board++ ))
    do
          boardOfTicTacToeGame[$board]="-"
    done
}
resetTheBoardOfGame
echo ${boardOfTicTacToeGame[@]}


function  tocheckWhoPlayFirst()
{
   optionToToss=$((RANDOM%2))
   if [ $optionToToss -eq 0 ]
    then 
        echo "First play Player"
    else
        echo "First play Computer"
  fi
}
tocheckWhoPlayFirst
function printBoard()
{
   echo "  |---|---|---|"
   echo "  |" ${boardOfTicTacToeGame[1]}" | "${boardOfTicTacToeGame[2]}" | "${boardOfTicTacToeGame[3]} "| "
   echo "  |---|---|---|"
   echo "  | "${boardOfTicTacToeGame[4]}" | "${boardOfTicTacToeGame[5]}" | "${boardOfTicTacToeGame[6]} "| "
   echo "  |---|---|---|"
   echo "  |" ${boardOfTicTacToeGame[7]}" | "${boardOfTicTacToeGame[8]}" | "${boardOfTicTacToeGame[9]} "| "
   echo "  |---|---|---|"
}
resetTheBoardOfGame
tocheckWhoPlayFirst
printBoard
