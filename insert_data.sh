#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  # ignore first line
  if [[ $year != year ]]
  then
    #get winner id
    winner_id=$($PSQL "select team_id from teams where name='$winner'")
    if [[ -z $winner_id ]]
    then
      result=$($PSQL "insert into teams(name) values('$winner')")
      if [[ $result == "INSERT 0 1" ]]
      then
         winner_id=$($PSQL "select team_id from teams where name='$winner'")
      fi
    fi
    #get opponent id
    opponent_id=$($PSQL "select team_id from teams where name='$opponent'")
    if [[ -z $opponent_id ]]
    then
      result=$($PSQL "insert into teams(name) values('$opponent')")
      if [[ $result == "INSERT 0 1" ]]
      then
         opponent_id=$($PSQL "select team_id from teams where name='$opponent'")
      fi
    fi
    result=$($PSQL "insert into games(year,winner_id,opponent_id,winner_goals,opponent_goals,round) values($year,$winner_id,$opponent_id,$winner_goals,$opponent_goals,'$round')")
    echo $result
  fi
done
