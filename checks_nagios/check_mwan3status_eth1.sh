#!/bin/sh

RES=`mwan3 status 2> /dev/null | awk 'FNR == 2'` #line 2 of the mwa3n status ouput 
echo "$RES"
