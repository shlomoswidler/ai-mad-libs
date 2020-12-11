# ai-mad-libs
Experimenting with AI

Create a [mad libs](https://en.wikipedia.org/wiki/Mad_Libs) style text.

Given an arbitrary source text, replace parts of speech with randomly chosen alternatives and show the result.

# Example
```
$ cat source.txt
Oh say can you see, by the dawn's early light, what so proudly we hailed at the twilight's last gleaming?

$ # generate the grammifier python script
$ python ipynb2py.py --input grammify.ipynb

$ # create the dictionary from the recipe
$ # python grammify.py pancakeRecipe.txt | awk -f dictionarize.awk > dict.txt

$ # invoke the grammifier to tag the parts of speech
$ python grammify.py source.txt > grammified.txt

$ # note the different madness levels in these examples
$ awk -f blankify.awk grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
Oh say can you mix, by the milk's early light, what so carefully we hailed at the twilight's last bubbling?

$ awk -f blankify.awk madness=5 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
Oh say can they serve, on top the sugar's early flour, what so proudly she hailed during the milk's crispy flipping?

$ awk -f blankify.awk madness=0 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
Oh say can you see, by the dawn's early light, what so proudly we hailed at the twilight's last gleaming?

$ awk -f blankify.awk madness=10 grammified.txt | awk -f adlib.awk dict.txt - | awk -f fill.awk grammified.txt -
yum mix serve she heat, during the salt's crispy sugar, he carefully immediately they smothered on top the milk's golden bubbling?
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
Converts a `grammified text` into a `dictionary`.

## `dictionary` format
The `dictionary` looks like this. This is an example dictionary created from a hypothetical pancake recipe:
```
<dictionary>
verb ending in ‘ing’ : flipping, bubbling
adjective : crispy, golden, tasty
noun (singular) : pancake, eggs, sugar, flour, milk, salt, syrup
pronoun : he, she, they
adverb : gently, carefully, immediately
verb : beat, mix, fry, heat, serve
past tense verb : browned, mixed, smothered
preposition : on top, during
exclamation : yum
</dictionary>
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
24 : she : pronoun
26 : carefully : abverb
38 : eggs : noun
43 : bubbling : verb ending in 'ing'
</template>
```
In a filled template, the second "` : `" and the part of speech are ignored, but present for reference.
## adlib.awk
Chooses the parts of speech requested by a `template` from a given `dictionary`.
Outputs a `template` that is filled.

## fill.awk
Reassembles the `grammified text`, substituting the parts of speech in the filled `template`. Outputs text.
