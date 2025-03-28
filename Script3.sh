#!/bin/bash 

FILE_PATH="/usr/share/dict/words"

USER_INPUT=""
RESULT=""

read -p "Podaj tekst do sprawdzenia: " USER_INPUT

for WORD in $USER_INPUT; do
    CLEANED_WORD=$(echo $WORD | tr -d '[:punct:]')
    IS_FOUND=$(grep -i -x "$CLEANED_WORD" $FILE_PATH)
    if [ -z "${IS_FOUND}" ]; then
        RESULT+=$(echo -e "\e[1;31m${WORD}\e[0m") 
    else
        RESULT+=$(echo $WORD)
    fi
    RESULT+=" "
done

echo -e "$RESULT"

# echo $USER_INPUT
