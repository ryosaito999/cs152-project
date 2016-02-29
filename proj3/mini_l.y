
%{
//Ryota Saito 861057726 
//Ben Quach 861061406

 #include <stdio.h>
 #include <stdlib.h>
 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 extern char* yytext;
 extern FILE * yyin;
 extern int yylex();
%}
%error-verbose
%union{
	int int_val;
	char* string_val;
}

%start  init

%left L_PAREN R_PAREN

%right SUB

%left MULT DIV MOD 

%left ADD

%left EQ NEQ LT GT LTE GTE

%right NOT

%left AND

%left OR

%right ASSIGN

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
%token COLON
%token SEMICOLON
%token COMMA
%token QUESTION
%token <string_val> IDENT
%%

init:
program identifier semicolon block end_program { printf ("program -> program identifier semicolon block end_program\n"); }
|
;

block:
declaration semicolon declaration_loop begin_program statement_loop   {printf("block -> declaration_loop begin_program statement semicolon statement_loop\n");}
;

declaration_loop: 
declaration semicolon declaration_loop  {printf("block -> declaration_loop semicolon declaration_loop\n");}
| { printf("declaration_loop -> EMPTY\n"); }
;

statement_loop: 
statement semicolon statement_loop { printf("statement_loop -> statement semicolon statement_loop \n"); }
| { printf("statement_loop -> EMPTY\n"); }
;

declaration:
identifier identifier_loop colon array_dec integer {printf("declaration -> identifier identifier_loop colon array_dec\n");}
;

identifier_loop: 
comma identifier identifier_loop { printf("identifier_loop -> comma identifier identifier_loop\n"); }
| { printf("identifier_loop -> EMPTY\n"); }
;

array_dec: 
array l_paren number r_paren of { printf("array_dec -> array l_paren number r_paren of\n"); }
| 
;
            
statement: 
var assign expression { printf("statement -> var assign expression\n"); }
| if bool_exp then statement semicolon statement_else_loop end_if { printf("statement -> if bool_exp then statement semicolon statement_else_loop endif\n"); }
| while bool_exp begin_loop statement semicolon statement_loop end_loop { printf("statement -> while bool_exp begin_loop statement semicolon statement_loop end_loop\n"); }
| do begin_loop statement semicolon statement_loop end_loop while bool_exp { printf("statement -> do begin_loop statement_loop end_loop while bool_exp\n"); }
| read var var_loop { printf("statement -> read var_loop\n"); }
| write var var_loop { printf("statement -> write var_loop\n"); }
| continue { printf("statement -> continue \n"); }
;

var_loop: 
comma var var_loop { printf("var_loop -> comma var var_loop \n"); }
| { printf("var_loop -> EMPTY\n"); }
;

statement_else_loop: 
statement semicolon statement_else_loop {printf("statement_else_loop -> statement semicolon statement_else_loop\n"); }
| statement semicolon else statement semicolon statement_loop { printf("statement_else_loop -> statement semicolon else statement semicolon statement_loop\n"); }
| { printf("statement_else_loop -> empty\n"); } 
;

bool_exp: 
relation_and_exp extra_or {printf("bool_exp -> relation_and_exp extra_or\n"); }
;

extra_or: 
or relation_and_exp extra_or {printf("extra_or -> or relation_and_exp extra_or\n"); }
| {printf("bool_exp -> EMPTY\n"); }
;

relation_and_exp: 
relation_exp extra_and{ printf("relation_and_exp -> relation_exp extra_and\n"); }
;
	
extra_and: 
and relation_exp extra_and{ printf("extra_and-> and relation_exp extra_and\n"); }
| { printf("extra_and-> EMPTY \n"); }
;

relation_exp:
relation_exp_branches { printf("relation_exp-> relation_exp_branches\n"); }
| not relation_exp_branches { printf("relation_exp-> not relation_exp_branches\n"); }
;

relation_exp_branches: 
expression comp expression { printf("relation_exp_branches -> expression comp expression\n"); }
| true { printf("relation_exp_branches ->  true\n"); }
| false { printf("relation_exp_branches ->  false\n"); }
| l_paren bool_exp r_paren { printf(" relation_exp_branches->  l_paren bool_exp r_paren\n"); }
;

expression:
multiplicative_exp add_sub_terms  { printf("expression -> multiplicative_exp add_sub_terms\n"); }
;

add_sub_terms: 
add_sub_terms tokens_1 multiplicative_exp  { printf("add_sub_terms -> add_sub_terms tokens_1 multiplicative_exp\n"); } 
|  { printf("add_sub_terms -> EMPTY\n"); } 
; 

tokens_1: 
add { printf("tokens_1 -> add\n"); } 
|sub { printf("tokens_1 -> sub\n"); } 

multiplicative_exp:
term  mult_div_mod_terms { printf("multiplicative_exp -> term  mult_div_mod_terms\n"); } 
; 
 
mult_div_mod_terms:
mult_div_mod_terms tokens_2 term { printf("multiplicative_exp -> mult_div_mod_terms tokens_2 term \n"); } 
| { printf("multiplicative_exp -> EMPTY \n"); } 
;

tokens_2:
mult { printf("tokens_2 -> mult \n"); } 
|div { printf("tokens_2 -> div \n"); } 
|mod { printf("tokens_2 -> mod \n"); } 
;

term: 
term_branches  { printf("term -> term_branches \n"); } 
| sub term_branches { printf("term -> sub term_branches \n"); } 

term_branches: 
var { printf("term_branches -> var \n"); } 
| number { printf("term_branches -> number \n"); } 
| l_paren expression r_paren { printf("term_branches -> l_paren expression r_paren \n"); } 
;

var: 
identifier add_exp { printf("var -> identifier add_exp \n"); } 
;

add_exp:
l_paren expression r_paren { printf("add_exp -> l_paren expression r_paren\n"); }
|
;

comp:
EQ {printf("comp -> EQ\n"); }
| NEQ {printf("comp -> NEQ\n"); }
| LT {printf("comp -> LT\n"); }
| GT {printf("comp -> GT\n"); }
| LTE {printf("comp -> LTE\n"); }
| GTE {printf("comp -> GTE\n"); }
;
                      
program:
PROGRAM { printf("program -> PROGRAM\n"); };

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
NUMBER { printf("number -> NUMBER(%s)\n", yytext); };

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
