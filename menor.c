go
int N
int x
int menor
get N
get x
x -> menor
N-- 
N>0 do:
	get x
	if x < menor:
		x->menor:
	N--:
put 'o menor numero - ' - menor
end