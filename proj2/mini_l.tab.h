/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUMBER = 258,
     PROGRAM = 259,
     BEGIN_PROGRAM = 260,
     END_PROGRAM = 261,
     INTEGER = 262,
     ARRAY = 263,
     OF = 264,
     IF = 265,
     THEN = 266,
     END_IF = 267,
     ELSE = 268,
     WHILE = 269,
     DO = 270,
     BEGIN_LOOP = 271,
     END_LOOP = 272,
     CONTINUE = 273,
     READ = 274,
     WRITE = 275,
     TRUE = 276,
     FALSE = 277,
     NOT = 278,
     AND = 279,
     OR = 280,
     L_PAREN = 281,
     R_PAREN = 282,
     SUB = 283,
     MULT = 284,
     DIV = 285,
     MOD = 286,
     ADD = 287,
     LT = 288,
     LTE = 289,
     GT = 290,
     GTE = 291,
     EQ = 292,
     NEQ = 293,
     ASSIGN = 294,
     COLON = 295,
     SEMICOLON = 296,
     COMMA = 297,
     L_BRACKET = 298,
     R_BRACKET = 299,
     QUESTION = 300,
     INDENT = 301
   };
#endif
/* Tokens.  */
#define NUMBER 258
#define PROGRAM 259
#define BEGIN_PROGRAM 260
#define END_PROGRAM 261
#define INTEGER 262
#define ARRAY 263
#define OF 264
#define IF 265
#define THEN 266
#define END_IF 267
#define ELSE 268
#define WHILE 269
#define DO 270
#define BEGIN_LOOP 271
#define END_LOOP 272
#define CONTINUE 273
#define READ 274
#define WRITE 275
#define TRUE 276
#define FALSE 277
#define NOT 278
#define AND 279
#define OR 280
#define L_PAREN 281
#define R_PAREN 282
#define SUB 283
#define MULT 284
#define DIV 285
#define MOD 286
#define ADD 287
#define LT 288
#define LTE 289
#define GT 290
#define GTE 291
#define EQ 292
#define NEQ 293
#define ASSIGN 294
#define COLON 295
#define SEMICOLON 296
#define COMMA 297
#define L_BRACKET 298
#define R_BRACKET 299
#define QUESTION 300
#define INDENT 301




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 17 "mini_l.y"
{
  int		int_val;
  char *	string_val;
}
/* Line 1529 of yacc.c.  */
#line 146 "mini_l.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

