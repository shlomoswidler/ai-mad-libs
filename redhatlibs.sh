#! /bin/bash

# NOTE: This requires GNU getopt.  On Mac OS X and FreeBSD, you have to install it separately
TEMP=`getopt -o vmds --long verbose,madness:,dictionary:,sourceFile: \
             -n 'redhatlibs' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

VERBOSE=false
MADNESS_OPT=
DICTIONARY=shakespeareDict.txt
SOURCE=source.txt
while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -m | --madness ) MADNESS_OPT="madness=$2"; shift 2 ;;
    -d | --dictionary ) DICTIONARY="$2"; shift 2;;
    -s | --sourceFile ) SOURCE="$2"; shift 2;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

TMPFILE=`mktemp`
if [ "$VERBOSE" == "true" ]; then
  VERBOSE_FILE=`mktemp`
  echo "temp file is $TMPFILE" > $VERBOSE_FILE
fi

if [ "$VERBOSE" == "true" ]; then
  VERBOSE_OUTPUT="| tee -a $VERBOSE_FILE"
fi

# generate the grammifier python script
python ipynb2py.py --input grammify.ipynb

# create the dictionary from the recipe (only necessary to create a new dictionary)
# python grammify.py pancakeRecipe.txt > $TMPFILE
# python grammify.py $TMPFILE | awk -f dictionarize.awk > $DICTIONARY

# invoke the grammifier to tag the parts of speech
eval "python grammify.py $SOURCE $VERBOSE_OUTPUT > $TMPFILE"

eval "awk -f blankify.awk $MADNESS_OPT $TMPFILE $VERBOSE_OUTPUT | awk -f adlib.awk $DICTIONARY - $VERBOSE_OUTPUT | awk -f fill.awk $TMPFILE - $VERBOSE_OUTPUT"

rm $TMPFILE

if [ "$VERBOSE" == "true" ]; then
  cat $VERBOSE_FILE
  rm $VERBOSE_FILE
fi
