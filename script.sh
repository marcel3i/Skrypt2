#!/bin/bash -f

DIRECTORY_NAME=""
FILE_NAME=""
SIZE_OPTION=""
TIME_OPTION=""
CONTENT_OPTION=""

while true; do
	clear
	echo "Wybierz opcje"
	echo "1. Nazwa pliku: $FILE_NAME"
	echo "2. Nazwa katalogui: $DIRECTORY_NAME"
	echo "3. Rozmiar pliku (format +100l, -2M): $SIZE_OPTION"
	echo "4. Data modfyikacji (format: -7, +25): $TIME_OPTION"
	echo "5. Zawartosc pliku: $CONTENT_OPTION"
	echo "6. Szukaj"
	echo "7. Koniec"
	read -p "Wybierz opcje (1-7): " CHOICE
	case $CHOICE in
	1)
	  read -p "Podaj nazwe pliku: " FILE_NAME
	  ;;
	2)
	  read -p "Podaj nazwe katalogu: " DIRECTORY_NAME
	  ;;
	3)
	  read -p "Podaj rozmiar pliku: " SIZE_OPTION
	  ;;
	4)
	  read -p "Podaj date mofycikacji: " TIME_OPTION
	  ;;
	5)
	  read -p "Podaj zawartosc pliku: " CONTENT_OPTION
	  ;;
	6)
	 echo "Szukanie ..."
	 echo 
	  cmd="find \"$DIRECTORY_NAME\" -name \"$FILE_NAME\""
	  cmd+=" -size $SIZE_OPTION"
	  cmd+=" -mtime $TIME_OPTION"
	  cmd+=" -exec grep \"$CONTENT_OPTION\" {} \;"
	 #echo "Komenda: $cmd"
	 RESULT=$(eval $cmd)
	 #echo $RESULT
	 if [ -z "${RESULT}" ]; then
	  echo "Plik nie istnieje"
	 else 
	  echo "Plik istnieje" 
	 fi
	 read -p "Wcisnij enter by wrocic do menu"
	 ;;
	7)
	  echo "Koniec programu"
	  break;
	 ;;
	*)
	  echo "Bledny input"
	  ;;
	esac
done
