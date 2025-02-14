#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_MENU() {
  # check to see if they entered an argument 
  if [[ -z $1 ]]
   then
    echo "Please provide an element as an argument."   
    exit 0
  else
    # Check to see if they entered a number
    if [[ $1 =~ ^[0-9]+$ ]]
      then
      # use the input as a atomic_number and get the details
      ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from properties join types using(type_id) join elements using(atomic_number) where atomic_number = $1")
      # Check for sql results
      if [[ -z $ELEMENT_ATOMIC_NUMBER ]]
        then
          echo "I could not find that element in the database."
          exit 0
      else
      echo "$ELEMENT_ATOMIC_NUMBER" | while read NAME ELEMENT SYMBOL ELEMENT TYPE ELEMENT MASS ELEMENT MELTING ELEMENT BOILING
        do
          echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi
    else    
      if [[ $(expr length "$1") -gt 2 ]]
        then
        # echo " arg is greater than 2"
          ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius, elements.atomic_number from properties join types using(type_id) join elements using(atomic_number) where name = '$1'")
        # check sql results
        if [[ -z $ELEMENT_ATOMIC_NUMBER ]]
        then
          echo "I could not find that element in the database."
          exit 0
        else
          echo "$ELEMENT_ATOMIC_NUMBER" | while read NAME ELEMENT SYMBOL ELEMENT TYPE ELEMENT MASS ELEMENT MELTING ELEMENT BOILING ELEMENT NUMBER
            do
              echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
            done
         fi
      else
        # echo "length of arg is less than 2"
          ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius, elements.atomic_number from properties join types using(type_id) join elements using(atomic_number) where symbol = '$1'")
        # Check for sql results
        if [[ -z $ELEMENT_ATOMIC_NUMBER ]]
          then
            echo "I could not find that element in the database."
            exit 0
        else
          echo "$ELEMENT_ATOMIC_NUMBER" | while read NAME ELEMENT SYMBOL ELEMENT TYPE ELEMENT MASS ELEMENT MELTING ELEMENT BOILING ELEMENT NUMBER
            do
              echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
            done
        fi
      fi    
    fi
  fi 
}
# Run the main function with an argument
MAIN_MENU $1
