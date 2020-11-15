%{
    #include <stdio.h>
    #include <strings.h>
    int yyerror(char *s);
    int yylex();
    int loadIndice(char *a,int x);
    char * loadtype(int a , int x);
    char* loadVar(char *a,int x);
    char *var[100];
    char *varFunc[100];
    char *types[10];
    int ind=0;
    int i=0;
    int pop=0;
    int tip;
    int tip2;
    int tam;
    int t=0;
    int j=0;
    int l=1;
    int h=1;
    int error=1;

%}

%union {
	char *pal;
	int num;
}

%token <pal> TYPE WORD STRING INC DEC FUNC 
%token <num> NUM
%token GO END SWAP TO BTO GET PUT DO SMALLER GREATER GREATEQ SMALEQ EQUAL DIF IF ELSE DEF OUT BREAK
%type <pal> prog 
%type <pal> decl   
%type <pal> Instr   
%type <pal> LInstr   
%type <pal> func   
%type <pal> exp
%type <pal> EXP      
%type <pal> value   
%type <pal> Else   
%type <pal> seq   


%%

prog: GO decl LInstr END func {printf("start\n%s%sstop\n\n%s",$2,$3,$5);}
	;

func: {$$="";}
    | func DEF FUNC '(' seq ')' ':' decl LInstr ':' {asprintf(&$$,"%s%s:\nnop\n%s\n%s\nreturn",$1,$3,$8,$9);} 
    ;

seq: WORD {varFunc[t++]=$1;}
    | seq WORD {varFunc[t++]=$2;}
    | NUM {pop++;var[ind++]="FuncParam";asprintf(&$$,"pushi %d\n",$1);j++;}
    | seq NUM {pop++;var[ind++]="FuncParam";asprintf(&$$,"%spushi %d\n",$1,$2);j++;}
    | WORD '[' EXP ']' {asprintf(&$$,"pushgp\n%s\npushi %d\nadd\npadd\nload 0",$3,loadIndice($1,pop));}
    | seq WORD '[' EXP ']' {asprintf(&$$,"%spushgp\n%s\npushi %d\nadd\npadd\nload 0",$1,$4,loadIndice($2,pop));}
    ;

decl:   {$$="";}
    |   decl TYPE WORD BTO STRING {var[ind++]=$3;types[i++]=$2;asprintf(&$$,"%spushs \"%s\"\n",$1,$5);}
    |   decl TYPE WORD {var[ind++]=$3;types[i++]=$2;asprintf(&$$,"%spushi 0\n",$1);}
    |   decl TYPE WORD BTO NUM {var[ind++]=$3;types[i++]=$2;asprintf(&$$,"%spushi %d\n",$1,$5);}
    |   decl TYPE WORD BTO WORD {var[ind++]=$3;types[i++]=$2;asprintf(&$$,"%s%s\n",$1,loadVar($5,pop));}
    |   decl TYPE WORD '[' NUM ']' {var[ind]=$3;types[i++]=$2;asprintf(&$$,"%spushn %d\n",$1,$5);ind=ind+$5;}
    |   decl TYPE WORD '[' WORD ']' {var[ind++]=$3;types[i++]=$2;asprintf(&$$,"%s\npushg %d\narray1:\npushg %d\npushi 1\nsub\njz array2\npushg %d\npushi 1\nsub\nstoreg %d\npushi 0\njump array1\narray2:\npushi 0\n",$1,loadIndice("FuncParam",pop),loadIndice($3,pop),loadIndice($3,pop),loadIndice($3,pop));}
    |   decl TYPE WORD '[' NUM ']' BTO '{' seq '}' {tam=$5;var[ind]=$3;types[i++]=$2;asprintf(&$$,"%s\n %s\n",$1,$9);ind=ind+j;}
    ;

LInstr: Instr {asprintf(&$$,"%s",$1);}
      | LInstr Instr {asprintf(&$$,"%s%s",$1,$2);}
        ;

Instr:  decl {yyerror("Redeclaração");}
        | GET WORD {tip=loadIndice($2,pop);asprintf(&$$,"%s %d\n",loadtype(tip-pop,0),tip);} 
    	| GET WORD '[' exp ']' {asprintf(&$$,"pushgp\n%s\npushi %d\nadd\npadd\nread\natoi\nstore 0\n",$4,loadIndice($2,pop));}
        | WORD BTO FUNC '(' seq ')' {asprintf(&$$,"%spusha %s\ncall\nnop\npop %d\n",$5,$3,pop);}
        | PUT NUM {asprintf(&$$,"pushi %d\nwritei\n",$2);}
        | PUT WORD {tip=loadIndice($2,pop);asprintf(&$$,"pushg %d\n%s\n",loadIndice($2,pop),loadtype(tip,1));}
    	| PUT WORD '-' WORD {tip=loadIndice($2,pop);tip2=loadIndice($4,pop);asprintf(&$$,"pushg %d\n%s\npushg %d\n%s\n",tip,loadtype(tip,1),tip2,loadtype(tip2,1));}
    	| PUT STRING WORD {tip=loadIndice($3,pop);asprintf(&$$,"pushs \"%s\"\nwrites\npushg %d\n%s\n",$2,tip,loadtype(loadIndice($3,pop),1));}
        | PUT WORD '[' exp ']'  {asprintf(&$$,"pushgp\n%s\npushi %d\nadd\npadd\nload 0\nwritei\n",$4,loadIndice($2,pop));}
        | PUT STRING WORD '[' exp ']'  {asprintf(&$$,"pushs %s\nwrites\npushgp\n%s\npushi %d\nadd\npadd\nload 0\nwritei\n",$2,$5,loadIndice($3,pop));}
    	| NUM TO WORD {asprintf(&$$,"pushi %d\nstoreg %d\n",$1,loadIndice($3,pop));}
        | WORD TO WORD {asprintf(&$$,"%s\nstoreg %d\n",loadVar($1,pop),loadIndice($3,pop));}
        | WORD BTO EXP    {asprintf(&$$,"%sstoreg %d\n",$3,loadIndice($1,pop));}
        | INC {asprintf(&$$,"%s\npushi 1\nadd\nstoreg %d\n",loadVar($1,pop),loadIndice($1,pop));}
        | DEC {asprintf(&$$,"%s\npushi 1\nsub\nstoreg %d\n",loadVar($1,pop),loadIndice($1,pop));}
        | BREAK {asprintf(&$$,"jump endDo%d\n",h);}
        | WORD '[' exp ']' BTO EXP {asprintf(&$$,"pushgp\n%s\npushi %d\nadd\npadd\n%s\nstore 0\n",$3,loadIndice($1,pop),$6);} 
        | SWAP WORD WORD {tip=loadIndice($2,pop);tip2=loadIndice($3,pop);asprintf(&$$,"pushg %d\npushg %d\nstoreg %d\nstoreg %d\n",tip,tip2,tip,tip2);}
        | SWAP WORD '[' exp ']' WORD '[' exp ']' {asprintf(&$$,"pushgp\n%s\npushi %d\nadd\npadd\npushgp\n%s\npushi %d\nadd\npadd\nload 0\npushgp\n%s\npushi %d\nadd\npadd\npushgp\n%s\npushi %d\nadd\npadd\nload 0\nstore 0\nstore 0\n",$4,loadIndice($2,pop),$8,loadIndice($6,pop),$8,loadIndice($6,pop),$4,loadIndice($2,pop));}
        | OUT value {asprintf(&$$,"%s\nstorel %d\n",$2,-t-1);}
        | EXP DO ':' LInstr ':' {asprintf(&$$,"do%d:%s%sjz endDo%d\n jump do%d\nendDo%d:\n",l,$4,$1,l,l,l);l++;}
        | IF EXP ':' LInstr ':' Else {asprintf(&$$,"%sjz more%d\n%sjump more2%d\nmore%d:\n%s\nmore2%d:\n",$2,h,$4,h,h,$6,h);h++;}
        
      
Else: {$$="";}
    | ELSE ':' LInstr ':' {asprintf(&$$,"%s\n:",$3);}
    ;
EXP : exp '+' exp {asprintf(&$$,"%s\n%s\nadd\n",$1,$3);}
    | exp '-' exp {asprintf(&$$,"%s\n%s\nsub\n",$1,$3);}
    | exp GREATER exp {asprintf(&$$,"%s\n%s\nsup\n",$1,$3);}
    | exp SMALLER exp {asprintf(&$$,"%s\n%s\ninf\n",$1,$3);}
    | exp GREATEQ exp {asprintf(&$$,"%s\npushi 1\nadd\n%s\nsup\n",$1,$3);}
    | exp EQUAL exp {asprintf(&$$,"%s\n%s\nequal\n",$1,$3);}
    | exp DIF exp {asprintf(&$$,"%s\n%s\nsub\n",$1,$3);}
    | exp {$$=$1;}

exp : exp '+' value {asprintf(&$$,"%s\n%s\nadd\n",$1,$3);}
    | exp '-' value {asprintf(&$$,"%s\n%s\nsub\n",$1,$3);}
    | exp '*' value {asprintf(&$$,"%s\n%s\nmul\n",$1,$3);}
    | exp '/' value {asprintf(&$$,"%s\n%s\ndiv\n",$1,$3);}
    | exp '%' value {asprintf(&$$,"%s\n%s\nmod\n",$1,$3);}
    | value {asprintf(&$$,"%s\n",$1);}
    ;

value: {$$="";}
     | '-' WORD {asprintf(&$$,"%s\nwritei\n",loadVar($2,pop));}
     | WORD  {asprintf(&$$,"%s",loadVar($1,pop));}
     | NUM   {asprintf(&$$,"pushi %d",$1);}
     | WORD '[' exp ']' {asprintf(&$$,"pushgp\n%s\npushi %d\nadd\npadd\nload 0",$3,loadIndice($1,pop));}
     ;


%%

#include "lex.yy.c"

int yyerror(char *s)
{
	fprintf(stderr, "ERRO SINTATICO: %s \n", s);   
	exit(-1);
}

int strcicmp(char const *a, char const *b)
{
    int d;
    for (;; a++, b++) {
        d = tolower(*a) - tolower(*b);
        if (d != 0 || !*a)
            return d;
    }
}

char* loadVar(char *a,int x){
    int i;
    char *str;
    for(i = 0;i<x;i++){
        if(strcicmp(varFunc[i],a) == 0){
            asprintf(&str,"pushl %d",-x+i);
            return str;
        }
    } 
    for(i = 0;i<10;i++){
        if(strcicmp(var[i],a) == 0){
            asprintf(&str,"pushg %d",i);
            return str;
        }
    }
}

int loadIndice(char *a,int x){
    int i;
    for(i=0;i<10;i++){
        if((strcicmp(var[i],a) == 0)) return i;
    }
    for(i=0;i<x;i++){
        if((strcicmp(varFunc[i],a) == 0)) return i;
    }
}

char * loadtype(int a,int x){ // x==0 R | x==1 W
  char *b = "int";
  char *c = "string";
  if(strcicmp(types[a],b) == 0){
  	if(x == 0){ return "read\natoi\nstoreg";}
  	else{ return "writei";}}
  if(strcicmp(types[a],c) == 0){
    if(x == 0){ return "read\natof\nstoreg";}
    else{ return "writes";}

  }}


int main()
{
    yyparse();
    return(0);
}

