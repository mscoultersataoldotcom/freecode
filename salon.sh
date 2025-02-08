#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name from services order by service_id")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID SERVICE NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  echo -e "\nWhat service number would you like today?\n"
  read SERVICE_ID_SELECTED
   # if not a number
   if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
     # send to main menu
     MAIN_MENU "That is not a valid service number."
    else
    # check if input is in the DB
     SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    # if input not found
    if [[ -z $SERVICE_NAME ]]
      then
    # send to main menu
    MAIN_MENU "You did not select a valid service number.\nPlease select from the list below."
    else
    # Get the customer info
    echo -e "\nYou selected to have a:$SERVICE_NAME\nWhat is your phone number?"
    read CUSTOMER_PHONE
      CUSTOMER_NAME=$($PSQL "SELECT name from customers WHERE phone='$CUSTOMER_PHONE'");
       # if customer doesn't exist
       if [[ -z $CUSTOMER_NAME ]]
        then
        # get new customer name
        echo -e "\nThat number is not in our system.  What's your name?"
        read CUSTOMER_NAME
        # insert new customer
        INSERT_CUSTOMER_RESULT=$($PSQL "Insert into customers (phone, name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')");
      fi
       # get customer_id
      CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone='$CUSTOMER_PHONE'");
      echo -e "\nWhat time today?\n"
       read SERVICE_TIME
       # if nothing entered then book for 8am
        if [[ -z $SERVICE_TIME ]]
        then
        SERVICE_TIME = '8:00'
        fi
         INSERT_APPOINTMENT_RESULT=$($PSQL "Insert into appointments (customer_id, service_id, time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED, '$SERVICE_TIME')");
         # display the appointment details 
         echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    EXIT
    
    
    fi
  fi
  
}
EXIT() {
  echo -e "\nThank you for using our services.\n"
}

MAIN_MENU