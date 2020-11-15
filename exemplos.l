%option noyywrap

%%
"go"	{return GO;}
"do"	{return DO;}
"int"	{yylval.pal=strdup(yytext);return TYPE;}
"string"	{yylval.pal=strdup(yytext);return TYPE;}
"swap"	{yylval.pal=strdup(yytext);return SWAP;}
"->"	{return TO;}
"<-"	{return BTO;}
"end"	{return END;}
"get"	{return GET;}
"put"	{return PUT;}
"if"	{return IF;}
"def"	{return DEF;}
\%		{return yytext[0];}
\+		{return yytext[0];}
\-		{return yytext[0];}
\/		{return yytext[0];}
\*		{return yytext[0];}
\:		{return yytext[0];}
\[		{return yytext[0];}
\]		{return yytext[0];}
\{		{return yytext[0];}
\}		{return yytext[0];}
\( 		{return yytext[0];}
\) 		{return yytext[0];}
[<]		{return SMALLER;}
[>]		{return GREATER;}
"<="		{return SMALEQ;}
">="		{return GREATEQ;}
"="		{return EQUAL;}
"~"		{return DIF;}
"ahoy"		{return ELSE;}
"out"	{return OUT;}
"break"	{return BREAK;}
"++"	{;}
"--"	{;}
[0-9]+	{yylval.num=atoi(yytext);return NUM;}
[a-zA-Z0-9]+	{yylval.pal=strdup(yytext);return WORD;}
[a-zA-Z0-9]+/[(]	{yylval.pal=strdup(yytext);return FUNC;}
[a-zA-Z0-9]+/"++"	{yylval.pal=strdup(yytext);return INC;}
[a-zA-Z0-9]+/"--"	{yylval.pal=strdup(yytext);return DEC;}
['][a-zA-Z0-9\- ]+/[']	{yylval.pal=strdup(yytext+1);return STRING;}
.	{;}
[ \n]	{;}
%%


