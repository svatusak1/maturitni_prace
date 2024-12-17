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
    START_OF_FILE = 258,           /* START_OF_FILE  */
    REMLIST = 259,                 /* REMLIST  */
    ADDLIST = 260,                 /* ADDLIST  */
    PLUS = 261,                    /* PLUS  */
    MINUS = 262,                   /* MINUS  */
    TIMES = 263,                   /* TIMES  */
    DIVIDE = 264,                  /* DIVIDE  */
    RCURL = 265,                   /* RCURL  */
    SEMICOL = 266,                 /* SEMICOL  */
    COMMA = 267,                   /* COMMA  */
    EQL = 268,                     /* EQL  */
    NEQ = 269,                     /* NEQ  */
    LSS = 270,                     /* LSS  */
    GTR = 271,                     /* GTR  */
    LEQ = 272,                     /* LEQ  */
    GEQ = 273,                     /* GEQ  */
    CALL = 274,                    /* CALL  */
    DEF = 275,                     /* DEF  */
    RTRN = 276,                    /* RTRN  */
    LOOP = 277,                    /* LOOP  */
    TO = 278,                      /* TO  */
    IF = 279,                      /* IF  */
    BYTE = 280,                    /* BYTE  */
    INT = 281,                     /* INT  */
    STRTYPE = 282,                 /* STRTYPE  */
    LPAREN = 283,                  /* LPAREN  */
    RPAREN = 284,                  /* RPAREN  */
    LBRACK = 285,                  /* LBRACK  */
    RBRACK = 286,                  /* RBRACK  */
    LCURL = 287,                   /* LCURL  */
    LISTTYPE = 288,                /* LISTTYPE  */
    VOIDTYPE = 289,                /* VOIDTYPE  */
    ASSIGN = 290,                  /* ASSIGN  */
    CAPACITY = 291,                /* CAPACITY  */
    LEN = 292,                     /* LEN  */
    COMMENT = 293,                 /* COMMENT  */
    MULTICOMMENT = 294,            /* MULTICOMMENT  */
    IDENT = 295,                   /* IDENT  */
    NUMBER = 296,                  /* NUMBER  */
    STR = 297                      /* STR  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define START_OF_FILE 258
#define REMLIST 259
#define ADDLIST 260
#define PLUS 261
#define MINUS 262
#define TIMES 263
#define DIVIDE 264
#define RCURL 265
#define SEMICOL 266
#define COMMA 267
#define EQL 268
#define NEQ 269
#define LSS 270
#define GTR 271
#define LEQ 272
#define GEQ 273
#define CALL 274
#define DEF 275
#define RTRN 276
#define LOOP 277
#define TO 278
#define IF 279
#define BYTE 280
#define INT 281
#define STRTYPE 282
#define LPAREN 283
#define RPAREN 284
#define LBRACK 285
#define RBRACK 286
#define LCURL 287
#define LISTTYPE 288
#define VOIDTYPE 289
#define ASSIGN 290
#define CAPACITY 291
#define LEN 292
#define COMMENT 293
#define MULTICOMMENT 294
#define IDENT 295
#define NUMBER 296
#define STR 297

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 22 "parser.y"

    char *node_type;
    struct node *node_obj;

#line 156 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
