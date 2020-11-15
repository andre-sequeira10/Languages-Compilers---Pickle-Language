go
int x <- 5 
int num
int prod <- 1
	x>0 do:
		get num
		prod <- prod * num 
		x--:
put prod
end