
%{
// Ryota Saito rsait001 861057726

#define YY_NO_INPUT
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
extern int currPos;
extern int currLine;
FILE * yyin;

%}
%error-verbose

%union{
  int		int_val;
  char *	string_val;
}

%start	init 
%token <int_val> NUMBER

%token PROGRAM
%token BEGIN_PROGRAM  
%token END_PROGRAM    
%token INTEGER
%token ARRAY        
%token OF           
%token IF          
%token THEN       
%token END_IF        
%token ELSE          
%token WHILE         
%token DO           
%token BEGIN_LOOP     
%token END_LOOP       
%token CONTINUE      
%token READ          
%token WRITE  
%token TRUE          
%token FALSE          
%token NOT           
%token AND           
%token OR     
%token L_PAREN
%token R_PAREN
%token SUB
%token MULT
%token DIV
%token MOD
%token ADD
%token LT
%token LTE
%token GT
%token GTE
%token EQ
%token NEQ
%token ASSIGN
%token COLON
%token SEMICOLON
%token COMMA
%token L_BRACKET
%token R_BRACKET
%token QUESTION
%token <string_val> INDENT

%left OR AND SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE

%%

init: program identifier semicolon block end_program  { printf ("program -> PROGRAM IDENT SEMICOLON block END_PROGRAM\n"); }
        |
        ;
         
block: declaration semicolon declaration_loop begin_program statement_loop   {printf("block -> declaration_loop begin_program statement_loop\n");}
		;

declaration_loop: declaration semicolon declaration_loop  {printf("block -> declaration_loop SEMICOLON declaration_loop\n");}
| { printf("declaration_loop -> EMPTY\n"); }
;

declaration: add

statement_loop: add





comp:
			EQ {printf("comp -> EQ\n"); }
			| NEQ {printf("comp -> NEQ\n"); }
			| LT {printf("comp -> LT\n"); }
			| GT {printf("comp -> GT\n"); }
			| LTE {printf("comp -> LTE\n"); }
			| GTE {printf("comp -> GTE\n"); }
			;


program:
	PROGRAM	{ printf("program -> PROGRAM\n"); };

begin_program:
	BEGIN_PROGRAM {printf("begin_program -> BEGINPROGRAM\n"); };

end_program:
	END_PROGRAM {printf("end_program -> ENDPROGRAM\n"); };

integer:    
	INTEGER { printf("integer -> INTEGER\n"); };

array:
	ARRAY { printf("array -> ARRAY\n"); };

of:
	OF {printf("of -> OF\n"); };

if:
	IF {printf("if -> IF\n"); };

then:
	THEN {printf("then -> THEN\n"); };

end_if:
	END_IF {printf("end_if -> END_IF\n"); };

else:
	ELSE {printf("else -> ELSE\n"); };

while:
	WHILE {printf("while -> WHILE\n"); };

do:
	DO {printf("do -> DO\n"); };

begin_loop:
	BEGIN_LOOP {printf("begin_loop -> BEGINLOOP\n"); };

end_loop:
	END_LOOP {printf("end_loop -> ENDLOOP\n"); };

continue: 
	CONTINUE {printf("continue-> CONTINUE\n"); };

read:
    READ {printf("read -> READ\n"); };

write:
	WRITE {printf("write -> WRITE\n"); };

true:
	TRUE {printf("true -> TRUE\n"); };

false:
	FALSE {printf("false -> FALSE\n"); };

not:
	NOT {printf("not -> NOT\n"); };


and:	
	AND {printf("and -> AND\n"); };

or:
	OR {printf("or -> OR\n"); };

l_paren:  
	L_PAREN { printf("l_paren -> L_PAREN\n"); };

r_paren:  
	R_PAREN { printf("r_paren -> R_PAREN\n"); };


sub:		
	SUB {printf("false -> SUB\n"); };

multiply:
	MULT {printf("false -> MULT\n"); };

divide:
	DIV {printf("false -> DIV\n"); };

mod:
	MOD {printf("false -> MOD\n"); };

add:
	ADD {printf("false -> ADD\n"); };

assign:
	ASSIGN {printf("assign -> ASSIGN\n"); };

colon:
	COLON { printf("colon -> COLON\n"); };

semicolon:
	SEMICOLON { printf("semicolon -> SEMICOLON\n"); };

comma:
	COMMA {printf("comma -> COMMA\n"); };

number:
	NUMBER { printf("number -> NUMBER(%d)\n", $1); };


identifier: 
	INDENT { printf("identifier -> INDENT(%s)\n", $1); };








 

%%

void yyerror(const char * msg)
{
   printf("Line %d, position %d: %s\n", currLine, currPos, msg);
}

int main(int argc, char** argv) {
	if(argc >= 2)
	{
		yyin = fopen(argv[1], "r");
		if(yyin == NULL)
		{
			yyin = stdin;
		}
   }

   else
   {
      yyin = stdin;
   }
   yyparse();
   return 0;

}
