#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU() {
if [[ -z $1 ]]
then
# user name alread entered
echo "Enter your username:"
read USER
else
USER=$1
fi
# echo "Enter your username:"
# read USER
SAVEPLAYED=0
SAVEBEST=0
if [[ $USER ]]
  then  
  # Check to see if the user exists in the database
    USER_DETAILS=$($PSQL "SELECT username, games_played, best_game from games WHERE username = '$USER'");
    if [[ -z $USER_DETAILS ]]
      then
        echo "Welcome, $USER! It looks like this is your first time here."
        USER_DETAILS=$($PSQL "INSERT into games (username, games_played, best_game) values('$USER',0,0)");
        MAIN_MENU $USER        
        # exit 0
    else      
      IFS="|"     
       echo "$USER_DETAILS" | while read NAME PLAYED BEST
        do
          if [[ -z $1 ]]
          then
            echo "Welcome back, $NAME! You have played $PLAYED games, and your best game took $BEST guesses."
          fi
          SAVEPLAYED=$PLAYED
          SAVEBEST=$BEST
        done 
        # Get a random number
        RAN=$((1 + SRANDOM % 999))
        echo "$RAN is random"
        COUNTER=0
        GUESSED=false    
        
        echo "Guess the secret number between 1 and 1000:"
        while true; do
        read NUMBER
        
        if [[ -z $NUMBER ]]
          then
            echo "That is not an integer, guess again:"            
          else
            # if a number
            if [[ $NUMBER =~ ^[0-9]+$ ]]
              then
              COUNTER=$((COUNTER+1))
              # echo "$COUNTER is the counter"
              if [[ $NUMBER == $RAN ]]
              then
                echo "You guessed it in $COUNTER tries. The secret number was $RAN. Nice job!"
                # Update the stats for the user
                SAVEPLAYED=$((SAVEPLAYED+1))
                if [[ $SAVEBEST -gt $COUNTER ]] || [[ $SAVEBEST -eq 0 ]]
                then
                    SAVEBEST=$COUNTER
                fi
                IFS="   
                "  
                USER_UPDATES=$($PSQL "UPDATE games SET games_played=$SAVEPLAYED, best_game=$SAVEBEST WHERE username='$USER'");
                GUESSED=true
              else
                if [[ $NUMBER -lt $RAN ]]
                then
                  echo "It's higher than that, guess again:"
                else
                  echo "It's lower than that, guess again:"
                fi
              fi
            else
              echo "That is not an integer, guess again:"    
            fi
          fi
         if [[ $GUESSED == true ]] 
         then
          break
         fi
        done
        exit 0
    fi
fi

}

MAIN_MENU