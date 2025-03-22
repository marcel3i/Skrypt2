#!/bin/bash -f 

fileName=""
directory=""
sizeOption=""
mtimeOption=""

while true; do
    clear
    echo "1. Nazwa pliku: $fileName"
    echo "2. Katalog: $directory"
    echo "3. Rozmar pliku (format: +100k, -2M): $sizeOption"
    echo "4. Data modyfikacji (format: -7, +25): $mtimeOption"
    echo "5. Szukaj"
    echo "6. Koniec"
    echo
    read -p "Wybierz opcje (1-6): " choice

    case $choice in
        1)
            read -p "Podaj nazwe pliku (np. *sh): " fileName
            ;;
        2)
            read -p "Podaj katalog pliku (domyślnie domowy): " directory
            if [[ "$directory" != /* ]]; then
                directory="$HOME/$directory"
            fi
            ;;
        3)
            read -p "Podaj rozmiar pliku (format: +100k, -2M): " sizeOption
            ;;
        4)
            read -p "Podaj date modyfikacji pliku (np. -7, +30): " mtimeOption
            ;;
        5) 
            if [ -z "$fileName" ]; then
                fileName="*"
            fi
            if [ -z "$directory" ]; then
                directory="$HOME"
            fi
            cmd="find \"$directory\" -name \"$fileName\""
            [ -n "$sizeOption" ] && cmd+=" -size $sizeOption"
            [ -n "$mtimeOption" ] && cmd+=" -mtime $mtimeOption"

            echo
            echo "Komenda: $cmd"
            echo
            echo "Wynik wyszukiwania: "
            eval $cmd

            if [ "$fileName" = "*" ]; then
                fileName=""
            fi
            if [ "$directory" = "$HOME" ]; then
                directory=""
            fi

            echo
            read -p "Wciśnij enter, by wrócić do menu..." 
            ;;
        6)
            echo "Zakoczono dzialanie skryptu"
            break
            ;;
        *)
            echo "Nieprawidlowy input"
            ;;
    esac
done
