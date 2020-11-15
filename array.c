go
int h
h <- array(5)
put h
end 

def array(y):
	int i <- 0
	int x[y]	
	i < y do:
		get x[i]
		i++:
	
	0 -> i
	i < 5 do:
		put x[i]
		i++:

	out 0: