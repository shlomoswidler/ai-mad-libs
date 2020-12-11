#! /bin/bash
DICTIONARY=${DICT:-dict.txt}
SOURCE=${SRC:-source.txt}
TMPFILE=`mktemp`

# generate the grammifier python script
python ipynb2py.py --input grammify.ipynb

# create the dictionary from the recipe (only necessary to create a new dictionary)
# python grammify.py pancakeRecipe.txt > $TMPFILE
# python grammify.py $TMPFILE | awk -f dictionarize.awk > $DICTIONARY

# invoke the grammifier to tag the parts of speech
python grammify.py $SOURCE > $TMPFILE

echo "-- default madness level (2)"
awk -f blankify.awk $TMPFILE | awk -f adlib.awk $DICTIONARY - | awk -f fill.awk $TMPFILE -
echo "-- madness level 5"
awk -f blankify.awk madness=5 $TMPFILE | awk -f adlib.awk $DICTIONARY - | awk -f fill.awk $TMPFILE -
echo "-- madness level 0"
awk -f blankify.awk madness=0 $TMPFILE | awk -f adlib.awk $DICTIONARY - | awk -f fill.awk $TMPFILE -
echo "-- madness level 10"
awk -f blankify.awk madness=10 $TMPFILE | awk -f adlib.awk $DICTIONARY - | awk -f fill.awk $TMPFILE -

rm $TMPFILE
