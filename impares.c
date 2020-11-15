go
int i <- 5
int num
int contagem <- 0

i > 0 do:
	get num
	if num % 2 ~ 0:
		contagem++
		put 'impar - ' num:
	i--:
put 'numeros impares - ' contagem
end 