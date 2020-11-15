go
int i <- 0
int c <- 0
int d <- 0
int t
int x[5]

i < 5 do:
	get x[i]
	i++:

0 -> i	

c < 4 do:
	d < 4 - c do:
		if x[d] > x [d+1]:
			swap x[d] x[d+1]:	
	d++:
c++
d <- 0:

i < 5 do:
	put x[i]
	i++:
end
