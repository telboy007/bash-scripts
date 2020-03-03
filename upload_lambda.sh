#! /bin/bash

# check aws cli is installed before starting the fun
AWS_CLI=`which aws`

if [ $? -ne 0 ]; then
  echo "AWS CLI is not installed; exiting"
  exit 1
else
  echo "Using AWS CLI found at $AWS_CLI"
fi

# check jq is installed before starting the fun
JQ=`which jq`

if [ $? -ne 0 ]; then
  echo "jq is not installed; exiting"
  exit 1
else
  echo "Using jq found at $JQ"
fi

# check we've got aws user name and mfa token value
# if [ $# -ne 3 ]; then
#   echo "Usage: $0 <AWS_USER_NAME> <AWS_ACCOUNT_NUMBER> <MFA_TOKEN_CODE>"
#   echo "Where:"
#   echo "   <AWS_USER_NAME> = Your AWS login username"
#   echo "   <AWS_ACCOUNT_NUMBER> = Your AWS Account Number"
#   echo "   <MFA_TOKEN_CODE> = Code from your virtual MFA device"
#   exit 2
# fi

# some variables
AWS_USER_NAME=$1
AWS_ACCOUNT_NUMBER=$2
MFA_TOKEN_CODE=$3
BUCKET="*** your bucket name here ***" # bucket name
FILENAME="deployment-package.zip" # upload key
TMP_FOLDER="/tmp/lambda-env-tmp/" # will be cleaned
OUTPUT_FOLDER="/tmp/lambda-env" # will be cleaned

# pathways
HERE=${BASH_SOURCE%/*} # relative path to this file's folder
LAMBDA_FOLDER="$HERE" # relative path
# PYTHON_ENV_FILE="$HERE/dependencies.zip" # relative path
OUTPUT_FILE="$OUTPUT_FOLDER/$FILENAME"

# create target folders
mkdir $TMP_FOLDER
mkdir $OUTPUT_FOLDER

# copy lambda function stuff to temporary folder
echo "Copying aws_lambda files"
cp -r $LAMBDA_FOLDER/* $TMP_FOLDER

# move there
echo "Zipping everything together"
cd $TMP_FOLDER
# zip everything to output folder (recursively and quietly)
zip -r -q $OUTPUT_FILE ./*
# move back
cd -

# lets get some temp creds and set some env variables
# echo "Getting temp credentials"
# TMP=/tmp/sts-$$.json
# aws sts get-session-token --serial-number arn:aws:iam::$AWS_ACCOUNT_NUMBER:mfa/$AWS_USER_NAME --token-code $MFA_TOKEN_CODE >$TMP
#
# echo "Setting environmental variables"
# export AWS_ACCESS_KEY_ID=`jq '.Credentials.AccessKeyId' <$TMP| sed -e 's/"//g'`
# export AWS_SECRET_ACCESS_KEY=`jq '.Credentials.SecretAccessKey' <$TMP| sed -e 's/"//g'`
# export AWS_SECURITY_TOKEN=`jq '.Credentials.SessionToken' <$TMP| sed -e 's/"//g'`

# upload to S3
echo "Uploading to S3 and copying link to paste into AWS console"
aws s3 cp $OUTPUT_FILE s3://$BUCKET/$FILENAME
echo "https://s3.amazonaws.com/$BUCKET/$FILENAME" | pbcopy

# clean everything
echo "Cleaning"
rm -rf $TMP_FOLDER
rm -rf $OUTPUT_FOLDER
rm -f $TMP

echo "Done"
