#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUNCATE=$($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS #Remember to change games_test.csv to games.csv
do

if [[ $YEAR != "year" ]]
then
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  
  if [[ -z $TEAM_ID ]]
  then 
    INSERT_INTO_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  fi

  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -z $TEAM_ID ]]
  then
    INSERT_INTO_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  fi

fi

if [[ $YEAR != "year" ]]
then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -n $WINNER_ID || -n $OPPONENT_ID ]]
  then
    INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  fi
fi

done