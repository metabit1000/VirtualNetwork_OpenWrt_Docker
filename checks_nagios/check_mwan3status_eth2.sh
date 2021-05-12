#!/bin/sh

RES=`mwan3 status 2> /dev/null | awk 'FNR == 3'` #line 3 of the mwa3n status ouput 
echo "$RES"
