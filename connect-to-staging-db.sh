#!/bin/bash

# change this to point to your clone of the handbook repo
handbook_scripts='/Documents/GitHub/handbook/scripts'
function set-aws {
    eval $($HOME/${handbook_scripts}/mfa.sh $*)
}

# main script
cd $HOME/${handbook_scripts}
flag=1
while [ ${flag} -eq 1 ]
do
  echo -e "\nAWS Credential Refresh & Staging DB Connection Utility."
  echo "---"
  echo "Please select an option:"
  echo "1. Connect to Staging DB"
  echo "2. Connect to Staging Redis"
  echo "3. Connect to Staging Redshift"
  echo "4. Refresh AWS credentials"
  read -p "Please answer 1, 2, 3 or 4: " DB_OPTION
  if [ $DB_OPTION -eq 1 ]
  then
    read -p "Please enter service name (leave blank for api): " SERVICE_NAME
    SERVICE=${SERVICE_NAME:api}
    echo "Connecting to Staging DB (may require your sudo password) ..."
    ENV=staging PORT=3306 SERVICE=$SERVICE ./connect-sql.sh
  elif [ $DB_OPTION -eq 2 ]
  then
    read -p "Please enter service name (leave blank for api): " SERVICE_NAME
    SERVICE=${SERVICE_NAME:api}
    echo "Connecting to Staging Redis (may require your sudo password) ..."
    ENV=staging PORT=6380 SERVICE=$SERVICE ./connect-redis.sh
  elif [ $DB_OPTION -eq 3 ]
  then
    echo "Connecting to Redshift (may require your sudo password) ..."
    SERVICE='airdna-staging' ./connect-redshift.sh
  elif [ $DB_OPTION -eq 4 ]
  then
    echo "Refreshing AWS credentials (may require MFA token)..."
    set-aws hostmaker
    set-aws hostmaker-staging
  else
    echo "Invalid option entered!"
  fi
done
