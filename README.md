# ai-mad-libs
Experimenting with AI

Create a [mad libs](https://en.wikipedia.org/wiki/Mad_Libs) style text.

Given an arbitrary source text, replace parts of speech with randomly chosen alternatives and show the result.

### The Jupyter Notebook [`red-hat-libs`](red-hat-libs.ipynb) shows the creation of a new Mad Libs.
To create a new dictionary, use the `grammify` and `dictionarize` steps explained below and in [`example.sh`](example.sh).

The remaining `awk` files are legacy - the steps have been reimplemented in Python in the [`red-hat-libs`](red-hat-libs.ipynb) Jupyter Notebook.

# Example
```
$ cat source.txt
Oh say can you see, by the dawn's early light, what so proudly we hailed at the twilight's last gleaming?

$ # generate the grammifier python script
$ python ipynb2py.py --input grammify.ipynb

$ # create the dictionary from the recipe (only necessary to create a new dictionary)
$ python grammify.py pancakeRecipe.txt > grammifiedRecipe.txt
$ python grammify.py grammifiedRecipe.txt | awk -f dictionarize.awk > dict.txt

$ # invoke the grammifier to tag the parts of speech
$ python grammify.py source.txt > grammified.txt

$ # note the different madness levels in these examples
$ awk -f blankify.awk grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
Oh say can you MIX , by the MILK 's early light , what so CAREFULLY we hailed at the twilight 's last BUBBLING ?

$ awk -f blankify.awk madness=5 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
Oh say can THEY SERVE , ON TOP the SUGAR 's early FLOUR , what so proudly SHE hailed DURING the MILK 's CRISPY FLIPPING ?

$ awk -f blankify.awk madness=0 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
Oh say can you see , by the dawn 's early light , what so proudly we hailed at the twilight 's last gleaming ?

$ awk -f blankify.awk madness=10 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
YUM MIX SERVE SHE HEAT , DURING the SALT 's CRISPY SUGAR , HE CAREFULLY IMMEDIATELY THEY SMOTHERED ON TOP the MILK 's GOLDEN BUBBLING ?
```
# Concepts
ai-mad-libs consists of five components that are assembled together into several pipelines.

```
   /source text/--->[grammify]--->/grammified text/
   
   /grammified text/--->[dictionarize]--->/dictionary/
   
   /grammified text/--->[blankify]--->/template/
   
   /template/+/dictionary/--->[adlib]--->/template/
   
   /template/+/grammified text/--->[fill]--->/result text/
```

## `source text` format
The `source text` should contain English text.

## grammify.ipynb
Converts the `source text` into the `grammified text`.

This marks up the text with the parts-of-speech. The Python [NLTK library](https://nltk.org/) is used to determine the parts of speech. The native NLTK output is more complicated than needed for mad libs, and the parts-of-speech are coded into three-letter terms, so the `nltk-tagsets-pos.txt` file is consulted to translate these NLTK terms into plain English terms, and to signal which parts of speech should be left untouched in the output (i.e., the articles 'a/an/the', punctuation, possessive endings, and foreign words).

This Jupyter Notebook can be converted into a python script that can be invoked from the command line directly, using the included utility `ipynb2py.py`.

## `grammified text` format
The `grammified text` contains the parts-of-speech tagged source text. It looks like this.
```
Oh : exclamation
say : verb
can : stet
you : stet
see : verb
, : stet
by : preposition
the : stet
dawn : noun (singular)
's : stet
early : adjective
light : noun (singular)
```
## dictionarize.awk
Converts a `grammified text` into a `dictionary`. All words are uppercased, to eliminate duplicates and to make it obvious in the output which words have been substituted.

## `dictionary` format
The `dictionary` looks like this. This is an example dictionary created from a hypothetical pancake recipe:
```
<dictionary>
verb ending in ‘ing’ : FLIPPING, BUBBLING
adjective : CRISPY, GOLDEN, TASTY
noun (singular) : PANCAKE, EGGS, SUGAR, FLOUR, MILK, SALT, SYRUP
pronoun : HE, SHE, THEY
adverb : GENTLY, CAREFULLY, IMMEDIATELY
verb : BEAT, MIX, FRY, HEAT, SERVE
past tense verb : BROWNED, MIXED, SMOTHERED
preposition : ON TOP, DURING
exclamation : YUM
</dictionary>
```

## dictionaries.db
The [`red-hat-libs`](red-hat-libs.sh) Jupyter Notebook reads a catalog of known dictionaries to present a drop-down allowing the user to choose one. The catalog is stored in the file `dictionaries.db`. Each line in this catalog points to a file in the project filesystem, along with a plain-text description. The format of each line is as follows:
```
filename : Plain-text description
```

## blankify.awk
Chooses words from within a `grammified text` to blank out. You can set the `madness` level from 0 (no blanks) to 10 (all possible blanks). If not specified, or an invalid value is specified, the default madness level of 2 is used.
Outputs a `template`.
#### Tip:
madness level 2 seems to work well for most texts, keeping enough of the original and still allowing room for humor.
## `template` format
A `template` represents the position of the part of speech within the source text and the word that should be placed there. When it only contains blanks, it looks like this:
```
<template>
24 : pronoun
26 : adverb
38 : noun
43 : verb ending in ‘ing’
</template>
```
When it contains blanks that have been filled from the dictionary, it looks like this:
```
<template>
24 : SHE : pronoun
26 : CAREFULLY : abverb
38 : EGGS : noun
43 : BUBBLING : verb ending in 'ing'
</template>
```
In a filled template, the second "` : `" and the part of speech are ignored, but present for reference.
## adlib.awk
Chooses the parts of speech requested by a `template` from a given `dictionary`.
Outputs a `template` that is filled.

## fill.awk
Reassembles the `grammified text`, substituting the parts of speech in the filled `template`. Outputs text.
