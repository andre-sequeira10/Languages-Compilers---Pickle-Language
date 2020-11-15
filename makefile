EXEC=exemplos

$(EXEC): $(EXEC).l $(EXEC).y
	flex $(EXEC).l
	yacc -v $(EXEC).y
	gcc -o $(EXEC) y.tab.c

teste: $(EXEC)
		./$(EXEC) < impares.c > impares.vm
		subl impares.vm

clean: 
	rm -f lex.yy.c y.tab.c y.tab.h $(EXEC) impares.vm


