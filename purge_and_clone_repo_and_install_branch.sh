#! /bin/bash
. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc
. $(brew --prefix nvm)/nvm.sh  # if installed via Brew

# check we've got a github branch name
if [ $# -ne 2 ]; then
  echo "Usage: $0 <repo_folder> <branch_name>"
  echo "Where:"
  echo "   <repo_folder> = Existing clone of GitHub repo"
  echo "   <branch_name> = GitHub branch name"
  exit 2
fi

# show what ya mamma gave ya
echo "Checking installed dependencies ..."
rvm list;nvm list;xcode-select --print-path

echo "Continue with installation? (y/n)"
read answer

if [ $answer == 'n' ]; then
  exit 1
else
  echo "Continuing with install ..."
fi

# be in the right folder and destroy all things
echo "Preparing ..."
cd ~/Documents/GitHub
rm -rf $1

# get a clean copy
echo "Cloning ..."
git clone https://github.com/***org_name***/$1.git
cd $1

# check out branch_name
echo "Checking out ..."
git checkout $2

# Install command goes here...
echo "Installing ..."
yarn

echo "Finished."
