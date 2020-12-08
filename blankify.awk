#
# Note that this expects input records to be on distinct lines
# As such it will not be able to handle newlines as part of the original text
#
BEGIN {
	FS = " : " 
	elems = 0
	valids = 0
	srand()
}
{
	++elems
	if ($2 != "stet" && $2 != "article") {
		valids++	
		data[elems] = $0
#		print valids "/ data[" elems "] = " data[elems]
	}
}
END { 
	if (madness == "" || madness < 0 || madness > 10) madness = 2
	numBlanks = int((valids + 3) * (madness / 10))
	if (numBlanks > valids) numBlanks = valids
	print "<template>"
	split(nullstr, rns)
	for (i = 1; i <= numBlanks; ++i) {
		do { # choose unique random numbers 
			rn = 1 + int(rand() * valids)
		} while (rn in rns)
#		print "rns[" rn "] = " rn
		rns[rn] = rn
	}
	n = 1
	for (j = 1; j <= elems; ++j) {
		if (j in data) {
			if (n in rns) { 
				split(data[j], pair, " : ")
				print j " : " pair[2] # " : " pair[1]
			}
			++n
		}
	}
	print "</template>"
}