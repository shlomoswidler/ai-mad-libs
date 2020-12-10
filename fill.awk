#
# Note that this expects input records to be on distinct lines
# As such it will not be able to handle newlines as part of the original text
#
BEGIN { 
	FS = " : "
	elemNum = 0
	inTemplate = 0
}
{ 
	if ($0 == "<template>") {
		inTemplate = 1
		next
	}
	if ($0 == "</template>") {
		inTemplate = 0
		next
	}
	if (inTemplate == 1) {
		repl[$1] = $2
	} else {
		++elemNum
		elem[elemNum] = $1
	}
}
END { 
	for (i = 1; i <= elemNum; ++i) {
		if (i in repl && index(repl[i], "<--") != 1) {
			printf("%s ", repl[i])
		} else {
			printf("%s ", elem[i])
		}
	}
	print ""
}
