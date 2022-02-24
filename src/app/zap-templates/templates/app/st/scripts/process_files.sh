#!/bin/bash
# Name - script.sh (bash read file names list from file)
# Author - 
# Usage - 
# ----------------------------------------------------------------
set -e
in="${1:-input.txt}"
 
[ ! -f "$in" ] && { echo "$0 - File $in not found."; exit 1; }

mkfile() { mkdir -p "$(dirname "$1")" && touch "$1" ;  }
LUA_FILE=""

while IFS= read -r file; do
  # echo -e "$file"
  if [[ $file = SOURCE_FILE_PATH* ]]
  then
    LUA_FILE=${file:17}
    # echo File is "$LUA_FILE"
    if [ -e $LUA_FILE ]; then
      # echo "File $LUA_FILE already exists! Will delete it."
      rm $LUA_FILE
    fi
    # echo "Creating file $LUA_FILE"
    mkfile $LUA_FILE
  else
    if [ -z "$LUA_FILE" ]
    then
      echo "$in is not properly formatted."
    else
      echo -e "$file" >> $LUA_FILE
    fi
  fi    
done <"${in}"

# while IFS= read -r file
# do
#     # echo -e "$file"
#   if [[ $file = SOURCE_FILE_PATH* ]]
#   then
#     LUA_FILE=${file:17}
#     # echo File is $LUA_FILE
#     if [ -e $LUA_FILE ]; then
#       # echo "File $LUA_FILE already exists! Will delete it."
#       rm $LUA_FILE
#     fi
#     echo "Creating file $LUA_FILE"
#     mkfile $LUA_FILE    
#   # elif [[ $file = =* ]]
#   # then
#   #   echo "Comment"
#   else
#     # echo file is $LUA_FILE
#     # echo "Line in a file: $file"
#     echo -e $file #>> $LUA_FILE
#   fi
#   # [[ $file = \#* ]] && continue
#   # echo "Running rm $file ..."
# done < "${in}"