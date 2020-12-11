#
# Note that this expects input records to be on distinct lines
# As such it will not be able to handle newlines as part of the original text
#
BEGIN { 
	FS = " : "
}
{ 
	if ($2 in data) {
		data[$2] = data[$2] ", " $1
	} else {
		data[$2] = $1
	}
}
END { 
	print "<dictionary>"
	for (key in data) {
		upper = toupper(data[key])
		len = split(upper, a, ", ")
		split(nullstr, unis, "-")
		for (el in a) {
			it = a[el]
			unis[it] = 0
		}
		printf("%s : ", key)
		n = 0
		for (u in unis) {
			if (n++ > 0) printf(", ")
			printf("%s", u) 
		} 
		print "" 
	}
	print "</dictionary>"
}
