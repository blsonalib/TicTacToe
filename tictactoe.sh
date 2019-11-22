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
