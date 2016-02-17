/*Benjamin Quach 861061406*/

%{
	#include "y.tab.h"
	int currLine = 1, currPos = 1;
%}

DIGIT    [0-9]
CHAR     ([_a-zA-Z])*[a-zA-Z]
IDENT    {CHAR}({CHAR}|{DIGIT})

%%


"program"            {currPos += yyleng; return PROGRAM;}
"beginprogram"       {currPos += yyleng; return BEGIN_PROGRAM;}
"endprogram"         {currPos += yyleng; return END_PROGRAM;}
"integer"            {currPos += yyleng; return INTEGER;}
"array"              {currPos += yyleng; return ARRAY;}
"of"                 {currPos += yyleng; return OF;}
"if"                 {currPos += yyleng; return IF;}
"then"               {currPos += yyleng; return THEN;}
"endif"              {currPos += yyleng; return END_IF;}
"else"               {currPos += yyleng; return ELSE;}
"while"              {currPos += yyleng; return WHILE;}
"do"                 {currPos += yyleng; return DO;}
"beginloop"          {currPos += yyleng; return BEGIN_LOOP;}
"endloop"            {currPos += yyleng; return END_LOOP;}
"continue"           {currPos += yyleng; return CONTINUE;}
"read"               {currPos += yyleng; return READ;}
"write"              {currPos += yyleng; return WRITE;}
"and"                {currPos += yyleng; return AND;}
"or"                 {currPos += yyleng; return OR;}
"not"                {currPos += yyleng; return NOT;}
"true"               {currPos += yyleng; return TRUE;}
"false"              {currPos += yyleng; return FALSE;}
"-"                  {currPos += yyleng; return SUB;}
"+"                  {currPos += yyleng; return ADD;}
"*"                  {currPos += yyleng; return MULT;}
"/"                  {currPos += yyleng; return DIV;}
"%"                  {currPos += yyleng; return MOD;}
"=="                 {currPos += yyleng; return EQ;}
"<>"                 {currPos += yyleng; return NEQ;}
"<"                  {currPos += yyleng; return LT;}
">"                  {currPos += yyleng; return GT;}
"<="                 {currPos += yyleng; return LTE;}
">="                 {currPos += yyleng; return GTE;}
";"                  {currPos += yyleng; return SEMICOLON;}
":"                  {currPos += yyleng; return COLON;}
"("                  {currPos += yyleng; return L_PAREN;}
")"                  {currPos += yyleng; return R_PAREN;}
":="                 {currPos += yyleng; return ASSIGN;}
","                  {currPos += yyleng; return COMMA;}
"#".*                {}

{DIGIT}+             {currPos += yyleng; return NUMBER;}
{CHAR}+({DIGIT}|{CHAR})*              {return IDENT;}
{DIGIT}({CHAR})+        {printf("Error at %d in column %d: identifier '%s' must start with a letter\n", currLine, currPos, yytext); exit(0);}
{CHAR}"_"                      {printf("Error at %d in column %d: identifier '%s' cannot end with an underscore\n", currLine, currPos, yytext); exit(0);}

[ \t]+         {/* ignore spaces */ currPos += yyleng;}

"\n"           {currLine++; currPos = 1;}

.               {printf("Error at %d in column %d in '%s'\n", currLine, currPos, yytext); exit(0);}


%%
