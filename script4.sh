#!/bin/bash

cat mail.txt | grep -E "^[a-z]+(\.[a-z]+)*@[a-z]+(\.[a-z]+)*\.[a-z]{2,}"

( echo "["; cat countries.csv | grep "Europe" | cut -d',' -f3,7 | sed -E "s/(.*),(.*)/  { \"country\": \"\1\", \"population\": \2}/" | sed '$!s/$/,/'; echo "]" )

sed "s/\r//" #usuwa carrieg return 
