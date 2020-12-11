#! /bin/bash
# generate the grammifier python script
python ipynb2py.py --input grammify.ipynb

# create the dictionary from the recipe (only necessary to create a new dictionary)
# python grammify.py pancakeRecipe.txt > grammifiedRecipe.txt
# python grammify.py grammifiedRecipe.txt | awk -f dictionarize.awk > dict.txt

# invoke the grammifier to tag the parts of speech
python grammify.py source.txt > grammified.txt

echo "-- default madness level (2)"
awk -f blankify.awk grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
echo "-- madness level 5"
awk -f blankify.awk madness=5 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
echo "-- madness level 0"
awk -f blankify.awk madness=0 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
echo "-- madness level 10"
awk -f blankify.awk madness=10 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
