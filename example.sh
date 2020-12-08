#! /bin/bash
awk -f blankify.awk madness=7 grammified.txt > blankTemplate.txt
awk -f adlib.awk dict.txt blankTemplate.txt > filledTemplate.txt
awk -f fill.awk grammified.txt filledTemplate.txt
