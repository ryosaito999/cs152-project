%{
 #include <stdio.h>
 #include <stdlib.h>
 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 extern char* yytext;
 FILE * yyin;
%}


%error-verbose
%union{
	int int_val;
	char* string_val;
}
%start  init
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
%token <string_val> IDENT

%left OR AND SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE

%%

init:
program identifier semicolon block end_program { printf ("program -> PROGRAM IDENT SEMICOLON BEGIN_PROGRAM END_PROGRAM\n"); }
|
;

program:
PROGRAM { printf("program -> PROGRAM\n"); };

block:
declaration semicolon declaration_loop begin_program statement_loop   {printf("block -> declaration_loop begin_program statement semicolon statement_loop\n");}
;

declaration_loop: declaration semicolon declaration_loop  {printf("block -> declaration_loop semicolon declaration_loop\n");}
| { printf("declaration_loop -> EMPTY\n"); }
;

statement_loop: statement semicolon statement_loop { printf("statement_loop -> statement semicolon statement_loop \n"); }
| { printf("statement_loop -> EMPTY\n"); }
;

declaration: identifier identifier_loop colon array_dec integer {printf("declaration -> identifier identifier_loop colon array_dec interger\n");}
;

identifier_loop: comma identifier identifier_loop { printf("identifier_loop -> comma identifier identifier_loop\n"); }
| { printf("identifier_loop -> EMPTY\n"); }
;

array_dec: array l_paren number r_paren of { printf("array_dec -> array l_paren number r_paren of\n"); }
| { printf("array_dec -> EMPTY\n"); }
;
            
statement: var assign expression { printf("statement -> var assign expression\n"); }
| if bool_exp then statement semicolon statement_else_loop end_if { printf("statement -> if bool_exp then statement semicolon statement_else_loop endif\n"); }
| while bool_exp begin_loop statement semicolon statement_loop end_loop { printf("statement -> while bool_exp begin_loop statement semicolon statement_loop end_loop\n"); }
| do begin_loop statement semicolon statement_loop end_loop while bool_exp { printf("statement -> do begin_loop statement_loop end_loop while bool_exp\n"); }
| read var var_loop { printf("statement -> read var_loop\n"); }
| write var var_loop { printf("statement -> write var_loop\n"); }
| continue { printf("statement -> continue \n"); }
;

var_loop: comma var var_loop { printf("var_loop -> comma var var_loop \n"); }
| { printf("var_loop -> EMPTY\n"); }
;

var: identifier { printf("var -> identifier\n"); }
| identifier l_paren expression r_paren { printf("var -> identifier l_paren expression r_paren\n"); }
;

expression:
IDENT { printf("expression -> IDENT \n"); }
| IDENT add expression { printf("expression -> IDENT add expression \n"); }
| IDENT sub expression { printf("expression -> IDENT sub expression \n"); }
| IDENT div expression { printf("expression -> IDENT div expression \n"); }
| IDENT mult expression { printf("expression -> IDENT mult expression \n"); }
| IDENT mod expression { printf("expression -> IDENT mod expression \n"); }
| NUMBER { printf("expression -> IDENT \n"); }
| array_dec 
;

bool_exp:
expression EQ expression { printf("bool_exp -> expression EQ expression \n"); }
| expression GT expression { printf("bool_exp -> expression GT expression \n"); }
| expression LT expression { printf("bool_exp -> expression LT expression\n"); }
| expression GTE expression { printf("bool_exp -> expression GTE expression \n"); }
| bool_exp and bool_exp { printf("bool_exp -> bool_exp and bool_exp \n"); }

mult_expression:
term
| term mult term
| term div term
| term mod term
;

term:
NUMBER
| IDENT
| L_PAREN expression R_PAREN
| IDENT L_PAREN expression R_PAREN
;

bool_exp:
relation_and_exp
| relation_and_exp or relation_and_exp
;

relation_and_exp: relation_exp relation_exp_loop { printf("relation_and_exp -> relation_exp relation_exp_loop \n"); }

relation_exp_loop: and relation_exp relation_exp_loop { printf("relation_exp_loop -> and relation_exp relation_exp_loop \n"); }
	| { printf("relation_exp_loop -> EMPTY \n"); }

statement_else_loop: statement semicolon statement_else_loop {printf("statement_else_loop -> statement semicolon statement_else_loop\n"); }
	| statement semicolon else statement semicolon statement_loop { printf("statement_else_loop -> statement semicolon else statement semicolon statement_loop\n"); }
	| { printf("statement_else_loop -> empty\n"); } 
	;

relation_exp: optional_not expression comp expression { printf("optional_not -> optional_not expression comp expression\n"); }
	| optional_not true { printf("optional_not -> optional_not true\n"); }
	| optional_not false { printf("optional_not -> optional_not false\n"); }
	| optional_not l_paren bool_exp r_paren { printf("optional_not -> optional_not l_paren bool_exp r_paren\n"); }
	;

optional_not: not  { printf("optional_not -> not\n"); }
	|  { printf("optional_not -> empty\n"); }
	;

comp:
EQ {printf("comp -> EQ\n"); }
| NEQ {printf("comp -> NEQ\n"); }
| LT {printf("comp -> LT\n"); }
| GT {printf("comp -> GT\n"); }
| LTE {printf("comp -> LTE\n"); }
| GTE {printf("comp -> GTE\n"); }
;
                      

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

mult:
MULT {printf("false -> MULT\n"); };

div:
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
NUMBER { printf("number -> NUMBER(%d)\n", yytext); };

identifier:
IDENT { printf("identifier -> IDENT(%s)\n", yytext); };      

%%
int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}

void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", currLine, currPos, msg);
}
