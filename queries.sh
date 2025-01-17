#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo $($PSQL "SELECT SUM(opponent_goals + winner_goals) FROM games")

echo -e "\nAverage number of goals in all games from the winning teams:"
echo $($PSQL "SELECT AVG(winner_goals) FROM games")

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo $($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")

echo -e "\nAverage number of goals in all games from both teams:"
echo $($PSQL "SELECT AVG(opponent_goals + winner_goals) FROM games")

echo -e "\nMost goals scored in a single game by one team:"
echo $($PSQL "SELECT MAX(GREATEST(winner_goals, opponent_goals)) FROM games")

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo $($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals>2")

echo -e "\nWinner of the 2018 tournament team name:"
echo $($PSQL "SELECT name FROM teams WHERE team_id = (SELECT winner_id FROM games WHERE round ILIKE 'final' AND year = 2018)")

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT name FROM teams WHERE team_id IN (SELECT winner_id FROM games WHERE round='Eighth-Final' AND year=2014 UNION SELECT opponent_id FROM games WHERE round='Eighth-Final' AND year=2014) ORDER BY name")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT name FROM teams WHERE team_id IN (SELECT winner_id FROM games) ORDER BY name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT games.year, t1.name FROM games FULL JOIN teams t1 ON games.winner_id=t1.team_id WHERE games.round='Final' ORDER BY games.year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT t1.name FROM games FULL JOIN teams t1 ON games.winner_id=t1.team_id FULL JOIN teams t2 ON games.opponent_id=t2.team_id WHERE t1.name LIKE 'Co%' AND t1.name LIKE 'Co%'")"
