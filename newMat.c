go 
int result 
result <- newMat(5)
end

def newMat(y):
int i <- 0
int acum <- 0
int acum2 <- 0
int new2[y]
int new[y]
i < y do:
		get new[i]
	acum++
	i++:

0 -> i

i < y do:
	if new[i] % 2 = 0:
		new2[acum2] <- new[i]
		acum2++:
	i++:

0 -> i

i < acum2 do:
	put new2[i]
	i++:

out 0:
