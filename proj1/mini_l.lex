%{   
   // Ryota Saito rsait001 861057726
   #include <stdio.h>
   #include <string.h>

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

program       {printf("PROGRAM\n");currPos += yyleng;}
beginprogram  {printf("BEGIN_PROGRAM\n");currPos += yyleng;}
endprogram    {printf("END_PROGRAM\n");currPos += yyleng;}
integer       {printf("INTEGER\n");currPos += yyleng;}
array         {printf("ARRAY\n");currPos += yyleng;}
of            {printf("OF\n");currPos += yyleng;}
if            {printf("IF\n");currPos += yyleng;}
then          {printf("THEN \n");currPos += yyleng;}
endif         {printf("ENDIF\n");currPos += yyleng;}
else          {printf("ELSE\n");currPos += yyleng;}
while         {printf("WHILE\n");currPos += yyleng;}
do            {printf("DO\n");currPos += yyleng;}
beginloop     {printf("BEGINLOOP\n");currPos += yyleng;}
endloop       {printf("ENDLOOP\n");currPos += yyleng;}
continue      {printf("CONTINUE\n");currPos += yyleng;}
read          {printf("READ\n");currPos += yyleng;}
write         {printf("WRITE\n");currPos += yyleng;}
true          {printf("TRUE\n");currPos += yyleng;}
false         {printf("FALSE\n");currPos += yyleng;}
not           {printf("NOT\n");currPos += yyleng;}
and           {printf("AND\n");currPos += yyleng;}
or            {printf("OR\n");currPos += yyleng;}


"("     {printf("L_PAREN\n");currPos += yyleng;}
")"     {printf("R_PAREN\n");currPos += yyleng;}
"-"     {printf("SUB\n");currPos += yyleng;}
"*"     {printf("MULT\n");currPos += yyleng;}
"/"     {printf("DIV\n");currPos += yyleng;}
"%"     {printf("MOD\n");currPos += yyleng;}
"+"     {printf("ADD\n");currPos += yyleng;}
"<"     {printf("LT\n");currPos += yyleng;}
"<="    {printf("LTE\n");currPos += yyleng;}
">"     {printf("GT\n");currPos += yyleng;}
">="    {printf("GTE\n");currPos += yyleng;}
"=="    {printf("EQ\n");currPos += yyleng;}
"<>"    {printf("NEQ\n");currPos += yyleng;}
":="    {printf("ASSIGN\n");currPos += yyleng;}
":"     {printf("COLON\n");currPos += yyleng;}
";"     {printf("SEMICOLON\n");currPos += yyleng;}
","     {printf("COMMA\n");currPos += yyleng;}
"["     { printf("L_BRACKET\n");currPos += yyleng;  }
"]"     { printf("R_BRACKET\n"); currPos += yyleng;  }


{DIGIT}+	   {printf("NUMBER %s\n", yytext); currPos += yyleng; }
{INDENT}     {printf("INDENT %s\n", yytext); currPos += yyleng; }

{WS}            {;currPos += yyleng;}
"\n"            {currLine++; currPos = 1;}

.               {printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currPos, yytext);exit(0);}
{BADLINE}       { printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter.\n", currLine, currPos, yytext);exit(0);}          
{BADLINE2}      { printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext);exit(0);}      


%%

main(int argc, char ** argv)
{
    
    if( argc == 2){
    //open with text file and 2 inputs -> for testing
        yyin = fopen(argv[1], "r");
        if(yyin == NULL)
        {
            yyin = stdin;
        }
    }
    
    else{
    //open with cat.min| executable
        yyin = stdin;
    }

   yylex();
}
