
%{
//Ryota Saito 861057726 
//Ben Quach 861061406

 #include <stdio.h>
 #include <stdlib.h>
 #include <iostream>
 #include <string>
 #include <vector>
 #include <stack>
 #include <sstream>
 #include "header.h"
 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 extern char* yytext;
 extern FILE * yyin;
 extern int yylex();
 using namespace std;

 stack<int> m_temporaries;
 //num temps
 int m_tn = 0;
 stack<int> m_predicates; 
 //num predicates
 int m_pn = 0;
 int currentLabel = 0;
 //so this is insanely fucking annoying
 //everything is done RECURSIVELY
 //but we need to keep track of the changes between recusrive stacks since we eval exp -> 5 + 5
 //so we need to throw them into fucking stacks
 stack<int> m_labelStack;
 stack<string> m_varStack;
 stack<string> m_compStack;
 vector<string> m_variables;
 stringstream output;

 void doOperation(string op,string operand2, string operand3);
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
program identifier semicolon block end_program 
{ 
    printf ("program -> program identifier semicolon block end_program\n"); 
    cout << endl;
    for(int i = 0 ; i < m_tn; i++)
	{
	    cout << "t" << i << endl;
	}
    for(int i = 0 ; i < m_pn; i++)
	{
	    cout << "p" << i << endl;
	}

    cout << output.str();
}
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
relation_and_exp extra_or {
printf("bool_exp -> relation_and_exp extra_or\n"); 
//push ident to predicate stack
}
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
relation_exp_branches 
{ printf("relation_exp-> relation_exp_branches\n"); }
| not relation_exp_branches { printf("relation_exp-> not relation_exp_branches\n"); }
;

relation_exp_branches: 
expression comp expression 
{ 
 printf("relation_exp_branches -> expression comp expression\n"); 
 //actually eval
 string t = m_varStack.top();
 m_varStack.pop();
 string t2 = m_varStack.top();
 m_varStack.pop();
 string comp = m_compStack.top();
 m_compStack.pop();
 output << comp << " p" << m_pn << "," << t2 << "," << t << endl;
 m_predicates.push(m_pn);
 m_pn++;
}
| true 
{
 printf("relation_exp_branches ->  true\n"); 
 output << "== p" << m_pn << ", 1, 1" << endl;
 m_predicates.push(m_pn);
 m_pn++;
 
}
| false 
{ 
 printf("relation_exp_branches ->  false\n"); 
 output << "== p" << m_pn << ", 1, 0" << endl;
 m_predicates.push(m_pn);
 m_pn++;

}
| l_paren bool_exp r_paren { printf(" relation_exp_branches->  l_paren bool_exp r_paren\n"); }
;

expression:
multiplicative_exp add_sub_terms  { printf("expression -> multiplicative_exp add_sub_terms\n"); }
;

add_sub_terms: 
add_sub_terms add multiplicative_exp  
{
 string t = m_varStack.top();
 m_varStack.pop();
 string t2 = m_varStack.top();
 m_varStack.pop(); 
 doOperation("+", t2, t);
} 
|
add_sub_terms sub multiplicative_exp  
{
 printf("add_sub_terms -> add_sub_terms sub multiplicative_exp\n"); 
 string t = m_varStack.top();
 m_varStack.pop();
 string t2 = m_varStack.top();
 m_varStack.pop(); 
 doOperation("-", t2, t);
} 
|  
{ printf("add_sub_terms -> EMPTY\n"); } 
; 


multiplicative_exp:
term  mult_div_mod_terms 
{
 printf("multiplicative_exp -> term  mult_div_mod_terms\n"); 
} 
; 
 
mult_div_mod_terms:
mult_div_mod_terms mult term { printf("multiplicative_exp -> mult_div_mod_terms mult term \n"); } 
|
mult_div_mod_terms div term { printf("multiplicative_exp -> mult_div_mod_terms div term \n"); } 
|
mult_div_mod_terms mod term { printf("multiplicative_exp -> mult_div_mod_terms mod term \n"); } 
| 
{ printf("multiplicative_exp -> EMPTY \n"); } 
;



term: 
term_branches  
{
 printf("term -> term_branches \n"); 
} 
| sub term_branches { printf("term -> sub term_branches \n"); } 

term_branches: 
var 
{
 printf("term_branches -> var \n"); 
} 
| 
number 
{
 printf("term_branches -> number \n"); 
} 
| 
l_paren expression r_paren 
{
 printf("term_branches -> l_paren expression r_paren \n"); 
} 
;

var: 
identifier add_exp 
{
 printf("var -> identifier add_exp \n"); 
 
} 
;

add_exp:
l_paren expression r_paren 
{
 printf("add_exp -> l_paren expression r_paren\n"); 
}
|
;

comp:
EQ 
{
 printf("comp -> EQ\n"); 
 //why push a comp onto a stack?
 //because we need this state of the recursion to 'return' something up
 m_compStack.push("==");
}
| NEQ 
{
 printf("comp -> NEQ\n"); 
 m_compStack.push("!=");
}
| LT 
{
 printf("comp -> LT\n"); 
 m_compStack.push("<");
}
| GT 
{
 printf("comp -> GT\n"); 
 m_compStack.push(">");
}
| LTE 
{
 printf("comp -> LTE\n"); 
 m_compStack.push("<=");
}
| GTE 
{
 printf("comp -> GTE\n"); 
 m_compStack.push(">=");
}
;
                      
program:
PROGRAM { 
    printf("program -> PROGRAM\n"); 
};

begin_program:
BEGIN_PROGRAM {
    printf("begin_program -> BEGINPROGRAM\n"); 
    output << "BEGIN" << endl;
};

end_program:
END_PROGRAM {printf("end_program -> ENDPROGRAM\n"); };

integer:
INTEGER { printf("integer -> INTEGER\n"); };

array:
ARRAY { printf("array -> ARRAY\n"); };

of:
OF {printf("of -> OF\n"); };

if:
IF {
    printf("if -> IF\n"); 
    //add a label here
    m_labelStack.push(currentLabel);
};

then:
THEN {printf("then -> THEN\n"); };

end_if:
END_IF {
    printf("end_if -> END_IF\n"); 
    if(m_labelStack.empty())
	{
	    //output error message
	}
    int last = m_labelStack.top();

    //so we have a label on the stack
};

else:
ELSE {printf("else -> ELSE\n"); };

while:
WHILE {
printf("while -> WHILE\n"); 

};

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
NUMBER {
 printf("number -> NUMBER(%s)\n", yytext); 
 //we hit the bottom of the recursion! yay!
 m_varStack.push(string(yytext));
};

identifier:
IDENT {

 printf("identifier -> IDENT(%s)\n", yytext); 
 //check if the test exists befoehand
 string s = yytext;


 m_varStack.push(yytext);
};      

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

void doOperation(string op, string operand2, string operand3)
{
    output << op << " t" << m_tn << " " << operand2 << " " << operand3 << endl;
    stringstream ss;
    ss << m_tn;
    m_varStack.push(ss.str());
    m_tn++;
}
