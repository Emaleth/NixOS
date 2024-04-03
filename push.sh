#!/bin/sh
git add . && kdialog --title "Input dialog" --inputbox "Commit message:" > tmp.out && git commit -F tmp.out && git push || rm tmp.out
