
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
 //int currentLabel = 0;

 //everything is done RECURSIVELY
 //but we need to keep track of the changes between recusrive stacks since we eval exp -> 5 + 5
 //so we need to throw them into fucking stacks

 stack<int> m_labelStack;
 int m_ln = 0;

 stack<string> m_varStack;
 stack<string> m_compStack;
 vector<string> m_variables;
 stringstream output;
 struct identStruct
 {
     string name;
     string type;
 };
 vector<identStruct> m_declarations;
 vector<string> m_arraydecs;

 stack<int> m_arrays;

 vector<string> m_finalDecs;
 void doOperationT(string op,string operand2, string operand3);


 bool readflag;
 string loopLabel;
 stack<int> m_loopStack;

 bool errorFlag = false;
 bool findDec(string dec);
 int getDec(string dec);
 typedef struct  linkedListNode                                                                                                                                                                                                                                                   
 {                                                                                                                                                                                                                                                                                
     linkedListNode* next;                                                                                                                                                                                                                                                        
     char val[256];                                                                                                                                                                                                                                                               
 }Node;   

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

%type<string_val> add_exp
%type<string_val> var
%type<int_val>number

%%

init:
program identifier_dec semicolon block end_program 
{ 
    if(!errorFlag)
	{
	    for(int i = 0 ; i < m_tn; i++)
		{
		    cout << "\t . t" << i << endl;
		}
	    for(int i = 0 ; i < m_pn; i++)
		{
		    cout << "\t . p" << i << endl;
		}

	    cout << output.str() << endl;
	}
    else
	{
	    cout << "Errors were found" << endl;
	}
}
|
;

block:
declaration semicolon declaration_loop begin_program statement_loop   {}
;

declaration_loop: 
declaration semicolon declaration_loop  {}
| {  }
;

statement_loop: 
statement semicolon statement_loop {  }
| {  }
;

declaration:
identifier_dec identifier_loop colon array_dec integer 
{
 
 //declare shit here
 //what if we have an array?
 string t = m_varStack.top();
 m_varStack.pop();
 if(m_arrays.empty())
 {
	 output << "\t . " << t << endl;

 }
 else
 {
	 output << "\t .[] " << m_varStack.top()  << ", " << t <<  endl;

 }
}
;

identifier_loop: 
comma identifier_dec identifier_loop { 
if(m_arrays.empty())
{
	 output << "\t . " << m_varStack.top() << endl;
     m_varStack.pop();

}

 }
| {  }
;

identifier_dec:
IDENT {

  
 //check if the test exists befoehand
 string s = yytext;
 if(findDec("_" + s))
     {
	 cout << "Redeclaration of " << s << " at line " << currLine << endl;
	 errorFlag=true;
	 
     }
 struct identStruct t;
 t.type="var";
 t.name = "_" + string(yytext);
 m_declarations.push_back(t);
 m_varStack.push("_"+ string(yytext));
};      

array_dec: 
array l_paren number r_paren of 
{ 
   m_declarations[m_declarations.size()-1].type="array";
 m_arrays.push(1);
}
| array l_paren sub number r_paren of 
{
    cout << "Cannot initialize a negative array at line " << currLine << endl;
    errorFlag = true;
}
|
;
            
statement: 
var assign expression 
{
    //icky
    stringstream out;
  

 //so right now, this only works for k := k
 //but what if we want k(t) := k? then we have issues
 //need to see if the VAR was an array because then we need to do a different assignment


 string t = m_varStack.top();
 m_varStack.pop();
 string t2 = m_varStack.top();
 m_varStack.pop();
 if(strcmp($1,"array"))
     {
	 //do some error checkin if we use an int as an array

	 int i = getDec(t2);
	 if(m_declarations[i].type == "array")
	     {
		 cout << "Cannot use array as an integer type at line " << currLine << endl;
		 errorFlag = true;
	     }
	 output << "\t" << "= " << t2 << ", " << t << endl;
	 stringstream ss;
	 ss << m_tn;
	 m_varStack.push("t" + ss.str());
	 m_tn++;
     }
 else
     {
	 //need to check if we are doing a []= or a =[]
	 //this right now only works if array is on the left



	 std::stringstream revout;
	 string t3 = m_varStack.top();
	 int i = getDec(t3);
	 if(m_declarations[i].type == "var")
	     {
		 cout << t3;
		 cout << "Cannot use integer as an array type at line " << currLine << endl;
		 errorFlag = true;
	     }
	 m_varStack.pop();
	 revout << m_tn;
	 output << "\t[]= " << t3 << ", " << t2 << ", "
		<< t << endl;
	 t = "t" + revout.str();
	 m_arrays.pop();
     }

 
}
| 
if ifbool_exp then statement semicolon statement_else_loop end_if 
{
  
 //change of fuckin plans
 //dont need a label for IF 
 //so push a label on if and then that will be elses label
 
}
| 
while bool_exp begin_loop statement semicolon statement_loop end_loop 
{ 
 stringstream out;    
 int l = m_labelStack.top();
 m_labelStack.pop();
 output << "\t:= L" << m_loopStack.top() << endl;
 output << ": L" << l << endl;
 m_loopStack.pop();


}
| do begin_loop statement semicolon statement_loop end_loop dowhile dobool_exp 
{
    //fuck me and fuck this     
    //reserve m_lns
    //so we know that do is the second thing on the stack



}
| read var var_loop { 

	 
 	if(strcmp($2, "array")){
		output << "\t.< " << m_varStack.top() << endl;
		m_varStack.pop();
	}
	else{
		string tmp = m_varStack.top();
		m_varStack.pop();
  		output << "\t.[]< " << m_varStack.top() << ", " << tmp << endl;
		m_varStack.pop();
	}

}
| write var var_loop 
{
  

 	if(strcmp($2, "array")){
		output << "\t.> " << m_varStack.top() << endl;
		m_varStack.pop();
	}
	else{
		string tmp = m_varStack.top();
		m_varStack.pop();
  		output << "\t.[]> " << m_varStack.top() << ", " << tmp << endl;
		m_varStack.pop();
	}

}
| continue 
{
    if(!m_loopStack.empty())
	{
 output << "\t:= L" << m_loopStack.top() << endl;
	}
    else
	{
	    cout << "Continue declared outside of loop at line " << currLine << endl;
	    errorFlag = true;
	}

}
;

var_loop: 
comma var var_loop { 
	string prefix;
	if(readflag){
		prefix = "\t.< ";
	}
	else{
		prefix = "\t.> ";
	}

 	if(strcmp($2, "array")){
		output << prefix << m_varStack.top() << endl;
		m_varStack.pop();

	}
	else{
		string tmp = m_varStack.top();
		m_varStack.pop();
		output << prefix  << " [] " << m_varStack.top() << "," << tmp << endl;
		m_varStack.pop();
	}



 }
| {  }
;

statement_else_loop: 
statement semicolon statement_else_loop 
{
  
 
}
| 
statement semicolon else statement semicolon statement_loop 
{
    //IF WE GET AN ELSE STATEMENT
    //POP SO THAT IF JUMPTS TO THE ELSE
    //THEN ADD A JUMP TO ENDIF
  

}
| {  } 
;

bool_exp: 
relation_and_exp extra_or {
 
    int p = m_predicates.top();
    m_predicates.pop();
 int l = m_labelStack.top();
 m_labelStack.pop();
 output << "\t! p" << p << ", p" << p << endl;
 output << "\t?:= L" << m_ln << ", p" << p << endl;

 m_labelStack.push(m_ln);
 m_ln++;
}
;

dobool_exp: 
relation_and_exp extra_or {
 
 int p = m_predicates.top();
 m_predicates.pop();
 int l = m_labelStack.top();
 m_labelStack.pop();
 
 output << "\t?:= L" << l << ", p" << p << endl;

}
;

ifbool_exp: 
relation_and_exp extra_or 
{
    stringstream out;
    //jump to the current thing in the stack
    m_labelStack.push(m_ln);
    int p = m_predicates.top();
    m_predicates.pop();
    output << "\t! p" << p << ", p" << p << endl;
    output << "\t?:= L" <<m_ln<< ", p" << p << endl;

    m_ln++;

}
;

extra_or: 
or relation_and_exp extra_or 
{
    stringstream out;
  
//push ident to predicate stack
 int t = m_predicates.top();
 m_predicates.pop();
 int t2 = m_predicates.top();
 m_predicates.pop();
 output << "\t||" << " p" << m_pn << ", p" << t2 << ", p" << t << endl;
 m_predicates.push(m_pn);
 m_pn++;
}
| { }
;

relation_and_exp: 
relation_exp extra_and{  }
;
	
extra_and: 
and relation_exp extra_and
{
    stringstream out;
  
//push ident to predicate stack
 int t = m_predicates.top();
 m_predicates.pop();
 int t2 = m_predicates.top();
 m_predicates.pop();
 output << "\t&&" << " p" << m_pn << ", p" << t2 << ", p" << t << endl;
 m_predicates.push(m_pn);
 m_pn++;
}
| {  }
;

relation_exp:
relation_exp_branches 
{  }
| not relation_exp_branches 
{
  
 //add a not expression here
}
;

relation_exp_branches: 
expression comp expression 
{ 
    stringstream out;
  
 //actually eval
 string t = m_varStack.top();
 m_varStack.pop();
 string t2 = m_varStack.top();
 m_varStack.pop();
 string comp = m_compStack.top();
 m_compStack.pop();
 output << "\t"<< comp << " p" << m_pn << ", " << t2 << ", " << t << endl;
 m_predicates.push(m_pn);
 m_pn++;
}
| true 
{
  
 output << "\t" << "== p" << m_pn << ", 1, 1" << endl;
 m_predicates.push(m_pn);
 m_pn++;
 
}
| false 
{ 
  
 output << "\t" << "== p" << m_pn << ", 1, 0" << endl;
 m_predicates.push(m_pn);
 m_pn++;

}
| l_paren bool_exp r_paren {  }
;

expression:
multiplicative_exp add_sub_terms  
{
  

}
;

add_sub_terms: 
add_sub_terms add multiplicative_exp  
{

 string t = m_varStack.top();

 m_varStack.pop();
 string t2 = m_varStack.top();
 m_varStack.pop(); 
 doOperationT("+", t2, t);
} 
|
add_sub_terms sub multiplicative_exp  
{
  
 string t = m_varStack.top();
 m_varStack.pop();
 string t2 = m_varStack.top();
 m_varStack.pop(); 
 doOperationT("-", t2, t);
} 
|  
{  } 
; 


multiplicative_exp:
term  mult_div_mod_terms 
{
  
} 
; 
 
mult_div_mod_terms:
mult_div_mod_terms mult term 
{
  
 string t = m_varStack.top();
 m_varStack.pop();
 string t2 = m_varStack.top();
 m_varStack.pop(); 
 doOperationT("*", t2, t);
} 
|
mult_div_mod_terms div term 
{
  
 string t = m_varStack.top();
 m_varStack.pop();
 string t2 = m_varStack.top();
 m_varStack.pop(); 
 doOperationT("/", t2, t);
} 
|
mult_div_mod_terms mod term 
{
  
 string t = m_varStack.top();
 m_varStack.pop();
 string t2 = m_varStack.top();
 m_varStack.pop(); 
 doOperationT("%", t2, t);
} 
| 
{
  
} 
;



term: 
term_branches  
{
  

} 
| 
sub term_branches 
{
  
} 

term_branches: 
var 
{
  
 if(!strcmp($1, "array"))
     {
	 string t = m_varStack.top();
	 m_varStack.pop();
	 string t2 = m_varStack.top();
	 m_varStack.pop();

    for(int i = 0; i < m_declarations.size(); i++)
	{
	    if(m_declarations[i].name==t2)
		{
		    //cout << m_declarations[i].name << " == " <<i << endl;
	 if(m_declarations[i].type == "var")
	     {

		 cout << "Cannot use variable as array type at line " << currLine << endl;
		 errorFlag = true;
	     }
		}
	}


	 //need to check if we are doing a []= or a =[]
	 //this right now only works if array is on the left
	 std::stringstream revout;
	 revout << m_tn;
	 output << "\t=[] t" << m_tn << ", " << t2 << ", "
		<< t << endl;

	 stringstream ss;
	 ss << m_tn;
	 m_varStack.push("t" + ss.str());
	 m_tn++;
	 t = "t" + revout.str();
	 m_arrays.pop();
     }

} 
| 
number 
{
  
} 
| 
l_paren expression r_paren 
{
  
} 
;

var: 
identifier add_exp 
{
  
 //unroll array if we have one
  
 
 $$ = $2;
} 
;

add_exp:
l_paren expression r_paren 
{
  
 //actually got an index so we report it
 m_arrays.push(1);

 $$ = "array";
}
|
{
    for(int i = 0; i < m_declarations.size(); i++)
	{
	    if(m_declarations[i].name==m_varStack.top())
		{
	 if(m_declarations[i].type == "array")
	     {

		 cout << "Cannot use variable as array type at line " << currLine << endl;
		 errorFlag = true;
	     }
		}
	}    $$="var";
}
;

comp:
EQ 
{
  
 //why push a comp onto a stack?
 //because we need this state of the recursion to 'return' something up
 m_compStack.push("==");
}
| NEQ 
{
  
 m_compStack.push("!=");
 }
| LT 
{
  
 m_compStack.push("<");
}
| GT 
{
  
 m_compStack.push(">");
}
| LTE 
{
  
 m_compStack.push("<=");
}
| GTE 
{
  
 m_compStack.push(">=");
}
;
                      
program:
PROGRAM { 
     
};

begin_program:
BEGIN_PROGRAM {
     
    output << ": START" << endl;
};

end_program:
END_PROGRAM { };

integer:
INTEGER {  };

array:
ARRAY {  };

of:
OF { };

if:
IF {
     
    
    
};

then:
THEN {
  

};

end_if:
END_IF {
  
 int l = m_labelStack.top();
 m_labelStack.pop();
 output << ": L" << l << endl;
};

else:
ELSE 
{
 int l = m_labelStack.top();
 m_labelStack.pop();
 output << ": L" << l << endl;
 m_labelStack.push(m_ln);
 m_ln++;
};

while:
WHILE 
{
	stringstream ss;
	ss << m_ln;
	loopLabel = "\t:= L" + ss.str();
    output << ": L" <<m_ln<<endl;
    m_labelStack.push(m_ln);
    m_loopStack.push(m_ln);

    m_ln++;  

};

dowhile:
WHILE
{
    //if theres a do while loop we dont push while onto the stack again

};

do:
DO {
    output << ": L" <<m_ln<<endl;
    m_loopStack.push(m_ln);
    m_labelStack.push(m_ln);
    m_ln++;
};

begin_loop:
BEGIN_LOOP 
{
 
};  

end_loop:
END_LOOP 
{
 
};

continue:
CONTINUE {
  
 //continue
 //output << "\tCONTINUE" << endl;
    
 
};

read:
READ { 
readflag = true;
};

write:
WRITE {
 
readflag = false;
};

true:
TRUE { };

false:
FALSE { };

not:
NOT { };

and:
AND 
{ 
  
};

or:
OR 
{
  

};

l_paren:
L_PAREN {  };

r_paren:
R_PAREN {  };

sub:
SUB { };

mult:
MULT { };

div:
DIV { };

mod:
MOD { };

add:
ADD { };

assign:
ASSIGN 
{
  

};

colon:
COLON {  };

semicolon:
SEMICOLON {  };

comma:
COMMA { };

number:
NUMBER {
  
 //we hit the bottom of the recursion! yay!
 m_varStack.push(string(yytext));
};

identifier:
IDENT {

  
 //check if the test exists befoehand

 string s = yytext;
 if(!findDec("_" + s))
     {
	 cout << "Could not find identifier " << s << " at line " << currLine << endl;
	 errorFlag = true;
     }
 m_varStack.push("_"+ string(yytext));
};      

%%
int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}

void yyerror(const char *msg) {
   
}

void doOperationT(string op, string operand2, string operand3)
{
    output << "\t"<< op << " t" << m_tn << ", " << operand2 << ", " << operand3 << endl;
    stringstream ss;
    ss << m_tn;
    m_varStack.push("t" + ss.str());
    m_tn++;

}


void doOperationP(string op, string operand2, string operand3)
{
    output << "\t" << op << " p" << m_tn << ", " << operand2 << ", " << operand3 << endl;
    stringstream ss;
    ss << m_pn;
    m_varStack.push(ss.str());
    m_pn++;
}


bool findDec(string dec)
{
    for(int i = 0; i < m_declarations.size(); i++)
	{
	    if(m_declarations[i].name == dec)
		return true;
	}
    return false;
}


int getDec(string dec)
{
    for(int i = 0; i < m_declarations.size(); i++)
	{
	    if(m_declarations[i].name==dec)
		{
		    //cout << m_declarations[i].name << " == " <<i << endl;
		return i;
		}
	}
    return -1;
}
