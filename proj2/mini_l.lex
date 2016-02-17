%{   
   // Ryota Saito rsait001 861057726
   #include <stdio.h>
   #include <string.h>
   #include <cstdio>
   #include <iostream>
   #include "y.tab.h"

   int currLine = 1, currPos = 0;
%}
DIGIT [0-9]
LETTER [a-zA-Z]
WS [ \t]+
US [_]

INDENT   {LETTER}((({LETTER}|{DIGIT})|{US})*({LETTER}|{DIGIT})+)*
BADLINE  ({US}|{DIGIT}){LETTER}((({LETTER}|{DIGIT})|{US})*({LETTER}|{DIGIT})+)*
BADLINE2 {LETTER}((({LETTER}|{DIGIT})|{US})*({LETTER}|{DIGIT})+)*{US}

%%
##.*$         {currLine++; currPos = 1;}

program;       {currPos += yyleng;return PROGRAM;}
beginprogram;  {currPos += yyleng;return BEGIN_PROGRAM;}
endprogram;    {currPos += yyleng;return END_PROGRAM;}
integer       {currPos += yyleng;return INTEGER;}
array         {currPos += yyleng;return ARRAY;}
of            {currPos += yyleng;return OF;}
if            {currPos += yyleng;return IF;}
then          {currPos += yyleng;return THEN;}
endif         {currPos += yyleng;return END_IF;}
else          {currPos += yyleng;return ELSE;}
while         {currPos += yyleng;return WHILE;}
do            {currPos += yyleng;return DO;}
beginloop     {currPos += yyleng;return BEGIN_LOOP;}
endloop       {currPos += yyleng;return END_LOOP;}
continue      {currPos += yyleng;return CONTINUE;}
read          {currPos += yyleng;return READ;}
write         {currPos += yyleng;return WRITE;}
true          {currPos += yyleng;return TRUE;}
false         {currPos += yyleng;return FALSE;}
not           {currPos += yyleng;return NOT;}
and           {currPos += yyleng;return AND;}
or            {currPos += yyleng;return OR;}


"("     {currPos += yyleng;return L_PAREN;}
")"     {currPos += yyleng;return R_PAREN;}
"-"     {currPos += yyleng;return SUB;}
"*"     {currPos += yyleng;return MULT;}
"/"     {currPos += yyleng;return DIV;}
"%"     {currPos += yyleng;return MOD;}
"+"     {currPos += yyleng;return ADD;}
"<"     {currPos += yyleng;return LT;}
"<="    {currPos += yyleng;return LTE;}
">"     {currPos += yyleng;return GT;}
">="    {currPos += yyleng;return GTE;}
"=="    {currPos += yyleng;return EQ;}
"<>"    {currPos += yyleng;return NEQ;}
":="    {currPos += yyleng;return ASSIGN;}
":"     {currPos += yyleng;return COLON;}
";"     {currPos += yyleng;return SEMI_COLON;}
","     {currPos += yyleng;return COMMA;}
"["     {currPos += yyleng;return L_BRACKET;}
"]"     {currPos += yyleng;return R_BRACKET;}
"?"     {currPos += yyleng; return QUESTION;}



{DIGIT}+	 {yylval.int_val = atoi(yytext); currPos += yyleng;return NUMBER;}
{INDENT}     {currPos += yyleng;return INDENT;}

{WS}            {;currPos += yyleng;}
"\n"            {currLine++; currPos = 1;}

.               {cerr << "SCANNER "; yyerror(""); exit(1);}
{BADLINE}       { printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter.\n", currLine, currPos, yytext);exit(0);}          
{BADLINE2}      { printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext);exit(0);}      


%%

main(int argc, char ** argv)
{
   yylex();
}
