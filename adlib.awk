# invoke with the dictionary (delimited by <dictionary> and </dictionary>
#   each on a line by itself)
# and the template of blanks
#

BEGIN { 
	FS = " : "
	inDict = 0
	srand()
}
{ 
	if ($0 == "<dictionary>") {
		inDict = 1
		next
	}
	if ($0 == "</dictionary>") {
		inDict = 0
		next
	}
	if (inDict == 1) {
		ofEach[$1] = split($2, arr, ", ")
		dict[$1] = $2
	} else {
		if ($0 == "<template>" || $0 == "</template>") next
		needEach[$2] = (needEach[$2] + 0) + 1
		res[$1] = $2
	}
}
END {
	print "<template>"
	for (i in res) {
		needA = res[i]
		numAvail = split(dict[needA], options, ", ")
#		print i " chooses from among " numAvail " " needA "s, need " needEach[needA] " of these"
		do {
			rn = 1 + int(rand() * numAvail)
		} while ((needA "_" rn) in used)
		used[ (needA "_" rn) ] = 1
		print i " : " options[rn] " : " needA
	}
	print "</template>"
}