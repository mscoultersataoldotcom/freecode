#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games,  teams");

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    # get the winner team_id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id from teams where name = '$WINNER'");

    # if not found
    if [[ -z $WINNER_TEAM_ID ]]
        then
      # set variable to null
      WINNER_TEAM_ID=null
      # insert into the teams table
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')");
      if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
          then
          echo Inserted into teams, $WINNER
      fi     
    fi
    # get the opponent team_id
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id from teams where name = '$OPPONENT'");

    # if not found
    if [[ -z $OPPONENT_TEAM_ID ]]
        then
      # set variable to null
      OPPONENT_TEAM_ID=null
      # insert into the teams table
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')");
      if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
          then
          echo Inserted into teams, $OPPONENT
      fi
    fi
 
   # get the winner team_id
   WINNER_TEAM_ID=$($PSQL "SELECT team_id from teams where name = '$WINNER'");
   # get the opponent team_id
   OPPONENT_TEAM_ID=$($PSQL "SELECT team_id from teams where name = '$OPPONENT'");
   # insert the game record
   INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)");
    if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
        then
        echo Inserted into games, $YEAR '$ROUND', $WINNER, $OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS
    fi
  fi

 
done
