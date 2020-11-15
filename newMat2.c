go
int result 
int x[5] <- {1 2 3 4 5}
result <- newMat(x 5)
end

def newMat(y k):
	int new[k]
	int i <- 0
	int j <- 0
	i < k do:
		if y[i] % 2 = 0:
			new[j] <- y[i]
			j++:
		i++:

	0 -> i

	i < j do:
		put new[i]
		i++:

out 1: 