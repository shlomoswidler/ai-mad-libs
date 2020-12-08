#! /bin/bash
# create the dictionary from the recipe
# grammify.sh pancakeRecipe.txt | awk -f dictionarize.awk > dict.txt

# generate the mad libs
# grammify.sh source.txt > grammified.txt
echo "-- default madness level (2)"
awk -f blankify.awk grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
echo "-- madness level 5"
awk -f blankify.awk madness=5 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
echo "-- madness level 0"
awk -f blankify.awk madness=0 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
echo "-- madness level 10"
awk -f blankify.awk madness=10 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
