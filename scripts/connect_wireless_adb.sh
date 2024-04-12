#!/bin/sh

PHONE=192.168.1.144
adb connect ${PHONE}:$( nmap -sT ${PHONE} -p30000-49999 | awk -F/ '/tcp open/{print $1}' )
