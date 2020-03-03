#! /bin/bash

find FOLDER_NAME -type f -name "*.route.js" -print -exec grep -h -e "app[.]" -e "endpoint" -e "actions" {} \;
