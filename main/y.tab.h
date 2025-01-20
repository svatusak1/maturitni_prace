/* A Bison parser, made by GNU Bison 3.7.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    NUMBER = 258,                  /* NUMBER  */
    STR = 259,                     /* STR  */
    IDENT = 260,                   /* IDENT  */
    START_OF_FILE = 261,           /* START_OF_FILE  */
    REMLIST = 262,                 /* REMLIST  */
    ADDLIST = 263,                 /* ADDLIST  */
    PLUS = 264,                    /* PLUS  */
    MINUS = 265,                   /* MINUS  */
    TIMES = 266,                   /* TIMES  */
    DIVIDE = 267,                  /* DIVIDE  */
    RCURL = 268,                   /* RCURL  */
    SEMICOL = 269,                 /* SEMICOL  */
    COMMA = 270,                   /* COMMA  */
    EQL = 271,                     /* EQL  */
    NEQ = 272,                     /* NEQ  */
    LSS = 273,                     /* LSS  */
    GTR = 274,                     /* GTR  */
    LEQ = 275,                     /* LEQ  */
    GEQ = 276,                     /* GEQ  */
    CALL = 277,                    /* CALL  */
    DEF = 278,                     /* DEF  */
    RTRN = 279,                    /* RTRN  */
    LOOP = 280,                    /* LOOP  */
    TO = 281,                      /* TO  */
    IF = 282,                      /* IF  */
    BYTE = 283,                    /* BYTE  */
    INT = 284,                     /* INT  */
    STRTYPE = 285,                 /* STRTYPE  */
    LPAREN = 286,                  /* LPAREN  */
    RPAREN = 287,                  /* RPAREN  */
    LBRACK = 288,                  /* LBRACK  */
    RBRACK = 289,                  /* RBRACK  */
    LCURL = 290,                   /* LCURL  */
    LISTTYPE = 291,                /* LISTTYPE  */
    VOIDTYPE = 292,                /* VOIDTYPE  */
    ASSIGN = 293,                  /* ASSIGN  */
    CAPACITY = 294,                /* CAPACITY  */
    LEN = 295,                     /* LEN  */
    COMMENT = 296,                 /* COMMENT  */
    MULTICOMMENT = 297             /* MULTICOMMENT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define NUMBER 258
#define STR 259
#define IDENT 260
#define START_OF_FILE 261
#define REMLIST 262
#define ADDLIST 263
#define PLUS 264
#define MINUS 265
#define TIMES 266
#define DIVIDE 267
#define RCURL 268
#define SEMICOL 269
#define COMMA 270
#define EQL 271
#define NEQ 272
#define LSS 273
#define GTR 274
#define LEQ 275
#define GEQ 276
#define CALL 277
#define DEF 278
#define RTRN 279
#define LOOP 280
#define TO 281
#define IF 282
#define BYTE 283
#define INT 284
#define STRTYPE 285
#define LPAREN 286
#define RPAREN 287
#define LBRACK 288
#define RBRACK 289
#define LCURL 290
#define LISTTYPE 291
#define VOIDTYPE 292
#define ASSIGN 293
#define CAPACITY 294
#define LEN 295
#define COMMENT 296
#define MULTICOMMENT 297

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 48 "parser.y"

    struct node *obj_node;
    char end_node[100];

#line 156 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
