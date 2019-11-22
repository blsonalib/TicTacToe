#!/bin/bash -x
echo "**********Welcome to TicTacToe Game**********"
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
