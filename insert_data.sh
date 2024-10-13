#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
# INSERT VALUES INTO TEAMS TABLE
if [[ $WINNER != 'winner' ]]
then
  # Insert values of WINNER into teams table
  # Get team_id of winner
  WIN_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #Check if winner team already exist
  if [[ -z $WIN_TEAM_ID ]]
  then
    WIN_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $WIN_TEAM_INSERT == 'INSERT 0 1' ]]
    then
      echo Inserted win team, $WINNER
    fi
    # Get new win_team_id
    WIN_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi

  # Insert values of OPPONENT into teams table
  # Get team_id of opponent
  OPP_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # Chech if opponent team already exist
  if [[ -z $OPP_TEAM_ID ]]
  then
    OPP_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $OPP_TEAM_INSERT == 'INSERT 0 1' ]]
    then
      echo Inserted opponent team, $OPPONENT
    fi
    # Get new opp_team_id
    OPP_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

  # INSERT VALUES INTO GAMES TABLE
GAME_INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WIN_GOALS, $OPP_GOALS, $WIN_TEAM_ID, $OPP_TEAM_ID)")
if [[ $GAME_INSERT_RESULT == 'INSERT 0 1' ]]
then
echo Inserted games, $YEAR $WINNER
fi
fi
done