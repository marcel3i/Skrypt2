#!/bin/bash 

FILE_PATH="/usr/share/dict/words"

echo "Podaj tekst do sprawdzenia (zakończ Ctrl+D):"
USER_INPUT=$(cat)
RESULT=""
echo "--------------"

while IFS= read -r LINE;do  #internal field seperator --> read whole line as one, an empty seperator
    for WORD in $LINE; do
        CLEANED_WORD=$(echo $WORD | tr -d '[:punct:]')
        IS_FOUND=$(grep -i -x "$CLEANED_WORD" $FILE_PATH)
        if [ -z "${IS_FOUND}" ]; then
            RESULT+="\e[1;31m${WORD}\e[0m "
        else
            RESULT+="${WORD} "
        fi
    done
    RESULT+="\n"
done <<< "$USER_INPUT"

echo -e "$RESULT"

# echo $USER_INPUT
