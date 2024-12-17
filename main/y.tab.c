/* A Bison parser, made by GNU Bison 3.7.4.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30704

/* Bison version string.  */
#define YYBISON_VERSION "3.7.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "parser.y"

#include <stdio.h>
#include <string.h>

int yylex(void);
int yyerror(const char *);

extern FILE *yyin;

struct node *mknode(struct node*, struct node*, char *);

struct node { 
    struct node *left; 
    struct node *right; 
    char *token; 
};
struct node *head;

void tree_free(struct node *, FILE *);

#line 92 "y.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
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

#line 234 "y.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_START_OF_FILE = 3,              /* START_OF_FILE  */
  YYSYMBOL_REMLIST = 4,                    /* REMLIST  */
  YYSYMBOL_ADDLIST = 5,                    /* ADDLIST  */
  YYSYMBOL_PLUS = 6,                       /* PLUS  */
  YYSYMBOL_MINUS = 7,                      /* MINUS  */
  YYSYMBOL_TIMES = 8,                      /* TIMES  */
  YYSYMBOL_DIVIDE = 9,                     /* DIVIDE  */
  YYSYMBOL_RCURL = 10,                     /* RCURL  */
  YYSYMBOL_SEMICOL = 11,                   /* SEMICOL  */
  YYSYMBOL_COMMA = 12,                     /* COMMA  */
  YYSYMBOL_EQL = 13,                       /* EQL  */
  YYSYMBOL_NEQ = 14,                       /* NEQ  */
  YYSYMBOL_LSS = 15,                       /* LSS  */
  YYSYMBOL_GTR = 16,                       /* GTR  */
  YYSYMBOL_LEQ = 17,                       /* LEQ  */
  YYSYMBOL_GEQ = 18,                       /* GEQ  */
  YYSYMBOL_CALL = 19,                      /* CALL  */
  YYSYMBOL_DEF = 20,                       /* DEF  */
  YYSYMBOL_RTRN = 21,                      /* RTRN  */
  YYSYMBOL_LOOP = 22,                      /* LOOP  */
  YYSYMBOL_TO = 23,                        /* TO  */
  YYSYMBOL_IF = 24,                        /* IF  */
  YYSYMBOL_BYTE = 25,                      /* BYTE  */
  YYSYMBOL_INT = 26,                       /* INT  */
  YYSYMBOL_STRTYPE = 27,                   /* STRTYPE  */
  YYSYMBOL_LPAREN = 28,                    /* LPAREN  */
  YYSYMBOL_RPAREN = 29,                    /* RPAREN  */
  YYSYMBOL_LBRACK = 30,                    /* LBRACK  */
  YYSYMBOL_RBRACK = 31,                    /* RBRACK  */
  YYSYMBOL_LCURL = 32,                     /* LCURL  */
  YYSYMBOL_LISTTYPE = 33,                  /* LISTTYPE  */
  YYSYMBOL_VOIDTYPE = 34,                  /* VOIDTYPE  */
  YYSYMBOL_ASSIGN = 35,                    /* ASSIGN  */
  YYSYMBOL_CAPACITY = 36,                  /* CAPACITY  */
  YYSYMBOL_LEN = 37,                       /* LEN  */
  YYSYMBOL_COMMENT = 38,                   /* COMMENT  */
  YYSYMBOL_MULTICOMMENT = 39,              /* MULTICOMMENT  */
  YYSYMBOL_IDENT = 40,                     /* IDENT  */
  YYSYMBOL_NUMBER = 41,                    /* NUMBER  */
  YYSYMBOL_STR = 42,                       /* STR  */
  YYSYMBOL_YYACCEPT = 43,                  /* $accept  */
  YYSYMBOL_st = 44,                        /* st  */
  YYSYMBOL_program = 45,                   /* program  */
  YYSYMBOL_statement = 46,                 /* statement  */
  YYSYMBOL_declarations = 47,              /* declarations  */
  YYSYMBOL_comment = 48,                   /* comment  */
  YYSYMBOL_change_val = 49,                /* change_val  */
  YYSYMBOL_list_change = 50,               /* list_change  */
  YYSYMBOL_func_dec = 51,                  /* func_dec  */
  YYSYMBOL_func_inp = 52,                  /* func_inp  */
  YYSYMBOL_arg_func = 53,                  /* arg_func  */
  YYSYMBOL_arg_func_type = 54,             /* arg_func_type  */
  YYSYMBOL_arg_func_list_type = 55,        /* arg_func_list_type  */
  YYSYMBOL_function_block = 56,            /* function_block  */
  YYSYMBOL_function_line = 57,             /* function_line  */
  YYSYMBOL_return = 58,                    /* return  */
  YYSYMBOL_expression = 59,                /* expression  */
  YYSYMBOL_function_call = 60,             /* function_call  */
  YYSYMBOL_arg_val = 61,                   /* arg_val  */
  YYSYMBOL_variable_dec = 62,              /* variable_dec  */
  YYSYMBOL_datatype = 63,                  /* datatype  */
  YYSYMBOL_list_type = 64,                 /* list_type  */
  YYSYMBOL_list_dec = 65,                  /* list_dec  */
  YYSYMBOL_elem_list = 66,                 /* elem_list  */
  YYSYMBOL_flow_control = 67,              /* flow_control  */
  YYSYMBOL_range = 68,                     /* range  */
  YYSYMBOL_step = 69,                      /* step  */
  YYSYMBOL_condition = 70,                 /* condition  */
  YYSYMBOL_comp = 71,                      /* comp  */
  YYSYMBOL_block = 72,                     /* block  */
  YYSYMBOL_list_indentation = 73           /* list_indentation  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  32
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   185

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  43
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  31
/* YYNRULES -- Number of rules.  */
#define YYNRULES  73
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  144

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   297


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint8 yyrline[] =
{
       0,    46,    46,    49,    50,    53,    54,    55,    56,    57,
      61,    62,    63,    67,    68,    71,    72,    75,    76,    79,
      86,    87,    88,    91,    95,    96,    97,    98,    99,   102,
     105,   106,   109,   110,   113,   116,   117,   118,   119,   120,
     121,   125,   129,   133,   134,   137,   138,   139,   142,   143,
     144,   148,   151,   151,   151,   151,   154,   157,   161,   162,
     165,   166,   169,   170,   173,   176,   179,   179,   179,   179,
     179,   179,   182,   185
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 0
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "START_OF_FILE",
  "REMLIST", "ADDLIST", "PLUS", "MINUS", "TIMES", "DIVIDE", "RCURL",
  "SEMICOL", "COMMA", "EQL", "NEQ", "LSS", "GTR", "LEQ", "GEQ", "CALL",
  "DEF", "RTRN", "LOOP", "TO", "IF", "BYTE", "INT", "STRTYPE", "LPAREN",
  "RPAREN", "LBRACK", "RBRACK", "LCURL", "LISTTYPE", "VOIDTYPE", "ASSIGN",
  "CAPACITY", "LEN", "COMMENT", "MULTICOMMENT", "IDENT", "NUMBER", "STR",
  "$accept", "st", "program", "statement", "declarations", "comment",
  "change_val", "list_change", "func_dec", "func_inp", "arg_func",
  "arg_func_type", "arg_func_list_type", "function_block", "function_line",
  "return", "expression", "function_call", "arg_val", "variable_dec",
  "datatype", "list_type", "list_dec", "elem_list", "flow_control",
  "range", "step", "condition", "comp", "block", "list_indentation", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297
};
#endif

#define YYPACT_NINF (-104)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      28,   108,    60,    48,   142,    26,    46,  -104,  -104,  -104,
      52,    56,  -104,  -104,     0,  -104,  -104,  -104,   108,  -104,
    -104,  -104,  -104,  -104,   164,  -104,  -104,    42,  -104,  -104,
    -104,  -104,  -104,    61,    63,    68,  -104,  -104,  -104,   142,
    -104,    57,  -104,    -8,    52,    72,   131,    52,    52,    52,
      52,    52,  -104,    52,    52,    52,    52,    73,    52,    52,
      52,  -104,    81,    80,    74,   148,    84,  -104,     2,   164,
     164,    20,   164,    12,    12,  -104,  -104,    52,   164,    -6,
      43,    54,   142,    52,   105,  -104,  -104,  -104,  -104,  -104,
    -104,    52,    91,    -8,    -8,  -104,   164,    52,  -104,  -104,
    -104,    95,   113,    89,     6,    52,   164,   108,  -104,  -104,
     111,   164,   120,   142,  -104,   136,   124,   173,   123,    79,
    -104,    52,    91,  -104,   144,    52,  -104,    37,  -104,  -104,
     171,  -104,    52,   164,  -104,  -104,    52,   164,    -9,   164,
    -104,    52,  -104,   164
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,     0,     0,     0,     0,     0,     0,    52,    53,    54,
       0,     0,    13,    14,    40,    41,    42,     2,     4,     5,
       9,     8,    16,    10,     6,    43,    11,     0,    55,    12,
       7,    44,     1,     0,     0,     0,    24,    25,    26,     0,
      28,     0,    27,     0,     0,    40,     0,     0,     0,     0,
       0,     0,     3,     0,     0,     0,     0,     0,    50,    50,
      50,    29,     0,     0,     0,     0,     0,    39,     0,    18,
      17,     0,    15,    35,    36,    37,    38,     0,    48,     0,
       0,     0,    22,     0,     0,    66,    67,    68,    69,    70,
      71,     0,     0,     0,     0,    73,    51,     0,    46,    47,
      45,     0,    20,     0,     0,     0,    65,     0,    61,    56,
       0,    49,     0,    22,    23,     0,     0,     0,     0,     0,
      21,     0,     0,    72,     0,     0,    32,     0,    30,    33,
      62,    60,     0,    34,    19,    31,     0,    58,     0,    64,
      63,     0,    57,    59
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
    -104,  -104,   -17,  -103,  -104,  -104,  -104,  -104,  -104,    71,
    -104,     3,  -104,  -104,    58,  -104,   -10,  -104,     9,  -104,
     -41,  -104,  -104,  -104,  -104,  -104,  -104,  -104,  -104,    59,
    -104
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,    17,    18,    19,    20,    21,    22,    23,   101,
     102,   103,    42,   127,   128,   129,    24,    25,    79,    26,
      27,    28,    29,   138,    30,   116,   140,    66,    91,   108,
      31
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      46,    52,    64,   141,    48,    49,    97,    41,    53,    54,
      55,    56,    53,    54,    55,    56,   126,     7,     8,     9,
      55,    56,   142,    98,   126,    63,    53,    54,    55,    56,
      50,     1,    93,    94,    65,    51,    93,    68,    69,    70,
      71,    72,    61,    73,    74,    75,    76,   134,    78,    78,
      78,    95,   109,   110,    43,    97,     3,     4,   125,     5,
      32,     6,     7,     8,     9,    10,    97,    96,    80,    81,
      11,     3,    99,   104,    44,    12,    13,    14,    15,    16,
      10,   106,    57,   100,    33,    34,    47,   111,    35,    58,
     117,    59,    45,    15,    16,   115,    60,    62,     3,     4,
     125,     5,    50,     6,     7,     8,     9,    10,    77,    82,
      83,   130,    11,    92,    84,   133,   105,    12,    13,    14,
      15,    16,   137,   107,   112,   113,   139,     3,     4,   114,
       5,   143,     6,     7,     8,     9,    10,    53,    54,    55,
      56,    11,    53,    54,    55,    56,    12,    13,    14,    15,
      16,   118,   119,   122,    53,    54,    55,    56,   124,   121,
      67,    85,    86,    87,    88,    89,    90,    36,    37,    38,
      53,    54,    55,    56,   132,    39,    40,    53,    54,    55,
      56,   131,   136,   123,   120,   135
};

static const yytype_uint8 yycheck[] =
{
      10,    18,    43,    12,     4,     5,    12,     4,     6,     7,
       8,     9,     6,     7,     8,     9,   119,    25,    26,    27,
       8,     9,    31,    29,   127,    33,     6,     7,     8,     9,
      30,     3,    30,    31,    44,    35,    30,    47,    48,    49,
      50,    51,    39,    53,    54,    55,    56,    10,    58,    59,
      60,    31,    93,    94,    28,    12,    19,    20,    21,    22,
       0,    24,    25,    26,    27,    28,    12,    77,    59,    60,
      33,    19,    29,    83,    28,    38,    39,    40,    41,    42,
      28,    91,    40,    29,    36,    37,    30,    97,    40,    28,
     107,    28,    40,    41,    42,   105,    28,    40,    19,    20,
      21,    22,    30,    24,    25,    26,    27,    28,    35,    28,
      30,   121,    33,    29,    40,   125,    11,    38,    39,    40,
      41,    42,   132,    32,    29,    12,   136,    19,    20,    40,
      22,   141,    24,    25,    26,    27,    28,     6,     7,     8,
       9,    33,     6,     7,     8,     9,    38,    39,    40,    41,
      42,    40,    32,    29,     6,     7,     8,     9,    35,    23,
      29,    13,    14,    15,    16,    17,    18,    25,    26,    27,
       6,     7,     8,     9,    30,    33,    34,     6,     7,     8,
       9,   122,    11,    10,   113,   127
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     3,    44,    19,    20,    22,    24,    25,    26,    27,
      28,    33,    38,    39,    40,    41,    42,    45,    46,    47,
      48,    49,    50,    51,    59,    60,    62,    63,    64,    65,
      67,    73,     0,    36,    37,    40,    25,    26,    27,    33,
      34,    54,    55,    28,    28,    40,    59,    30,     4,     5,
      30,    35,    45,     6,     7,     8,     9,    40,    28,    28,
      28,    54,    40,    33,    63,    59,    70,    29,    59,    59,
      59,    59,    59,    59,    59,    59,    59,    35,    59,    61,
      61,    61,    28,    30,    40,    13,    14,    15,    16,    17,
      18,    71,    29,    30,    31,    31,    59,    12,    29,    29,
      29,    52,    53,    54,    59,    11,    59,    32,    72,    63,
      63,    59,    29,    12,    40,    59,    68,    45,    40,    32,
      52,    23,    29,    10,    35,    21,    46,    56,    57,    58,
      59,    72,    30,    59,    10,    57,    11,    59,    66,    59,
      69,    12,    31,    59
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    43,    44,    45,    45,    46,    46,    46,    46,    46,
      47,    47,    47,    48,    48,    49,    49,    50,    50,    51,
      52,    52,    52,    53,    54,    54,    54,    54,    54,    55,
      56,    56,    57,    57,    58,    59,    59,    59,    59,    59,
      59,    59,    59,    59,    59,    60,    60,    60,    61,    61,
      61,    62,    63,    63,    63,    63,    64,    65,    66,    66,
      67,    67,    68,    68,    69,    70,    71,    71,    71,    71,
      71,    71,    72,    73
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     2,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     3,     1,     3,     3,     9,
       1,     3,     0,     2,     1,     1,     1,     1,     1,     2,
       1,     2,     1,     1,     2,     3,     3,     3,     3,     3,
       1,     1,     1,     1,     1,     5,     5,     5,     1,     3,
       0,     4,     1,     1,     1,     1,     5,    10,     1,     3,
       8,     5,     3,     5,     1,     3,     1,     1,     1,     1,
       1,     1,     3,     4
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
# ifndef YY_LOCATION_PRINT
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif


# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yykind < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yykind], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2: /* st: START_OF_FILE program  */
#line 46 "parser.y"
                           { (yyval.node_obj) = mknode((yyvsp[0].node_obj), NULL, "ENTRY"); head = (yyval.node_obj); }
#line 1388 "y.tab.c"
    break;

  case 3: /* program: statement program  */
#line 49 "parser.y"
                            { (yyval.node_obj) = mknode((yyvsp[-1].node_obj), (yyvsp[0].node_obj), "statement"); }
#line 1394 "y.tab.c"
    break;

  case 4: /* program: statement  */
#line 50 "parser.y"
                    { (yyval.node_obj) = (yyvsp[0].node_obj); }
#line 1400 "y.tab.c"
    break;

  case 19: /* func_dec: DEF arg_func_type IDENT LPAREN func_inp RPAREN LCURL function_block RCURL  */
#line 81 "parser.y"
             { 
                (yyval.node_obj) = mknode(mknode(NULL, NULL, (yyvsp[-6].node_type)), mknode((yyvsp[-7].node_obj), mknode((yyvsp[-4].node_obj), (yyvsp[-1].node_obj), "function body, input"), "function parameters"), "function dec"); 
             }
#line 1408 "y.tab.c"
    break;

  case 21: /* func_inp: arg_func COMMA func_inp  */
#line 87 "parser.y"
                                   { (yyval.node_obj) = mknode((yyvsp[0].node_obj), (yyvsp[-2].node_obj), "function args"); }
#line 1414 "y.tab.c"
    break;

  case 22: /* func_inp: %empty  */
#line 88 "parser.y"
           { (yyval.node_obj) = mknode(NULL, NULL, "empty arg"); }
#line 1420 "y.tab.c"
    break;

  case 23: /* arg_func: arg_func_type IDENT  */
#line 91 "parser.y"
                               { (yyval.node_obj) = mknode((yyvsp[-1].node_obj), mknode(NULL, NULL, (yyvsp[0].node_type)), "function argument"); }
#line 1426 "y.tab.c"
    break;

  case 24: /* arg_func_type: BYTE  */
#line 95 "parser.y"
                     { (yyval.node_obj) = mknode(NULL, NULL, (yyvsp[0].node_type)); }
#line 1432 "y.tab.c"
    break;

  case 25: /* arg_func_type: INT  */
#line 96 "parser.y"
                    { (yyval.node_obj) = mknode(NULL, NULL, (yyvsp[0].node_type)); }
#line 1438 "y.tab.c"
    break;

  case 26: /* arg_func_type: STRTYPE  */
#line 97 "parser.y"
                        { (yyval.node_obj) = mknode(NULL, NULL, (yyvsp[0].node_type)); }
#line 1444 "y.tab.c"
    break;

  case 27: /* arg_func_type: arg_func_list_type  */
#line 98 "parser.y"
                                   { (yyval.node_obj) = mknode((yyvsp[0].node_obj), NULL, "list type"); }
#line 1450 "y.tab.c"
    break;

  case 28: /* arg_func_type: VOIDTYPE  */
#line 99 "parser.y"
                         { (yyval.node_obj) = mknode(NULL, NULL, (yyvsp[0].node_type)); }
#line 1456 "y.tab.c"
    break;

  case 29: /* arg_func_list_type: LISTTYPE arg_func_type  */
#line 102 "parser.y"
                                            { (yyval.node_obj) = mknode((yyvsp[0].node_obj), NULL, (yyvsp[-1].node_type)); }
#line 1462 "y.tab.c"
    break;

  case 34: /* return: RTRN expression  */
#line 113 "parser.y"
                         { (yyval.node_obj) = mknode((yyvsp[0].node_obj), NULL, "return"); }
#line 1468 "y.tab.c"
    break;

  case 35: /* expression: expression PLUS expression  */
#line 116 "parser.y"
                                        { (yyval.node_obj) = mknode((yyvsp[-2].node_obj), (yyvsp[0].node_obj), "+"); }
#line 1474 "y.tab.c"
    break;

  case 36: /* expression: expression MINUS expression  */
#line 117 "parser.y"
                                         { (yyval.node_obj) = mknode((yyvsp[-2].node_obj), (yyvsp[0].node_obj), "+"); }
#line 1480 "y.tab.c"
    break;

  case 37: /* expression: expression TIMES expression  */
#line 118 "parser.y"
                                         { (yyval.node_obj) = mknode((yyvsp[-2].node_obj), (yyvsp[0].node_obj), "+"); }
#line 1486 "y.tab.c"
    break;

  case 38: /* expression: expression DIVIDE expression  */
#line 119 "parser.y"
                                          { (yyval.node_obj) = mknode((yyvsp[-2].node_obj), (yyvsp[0].node_obj), "+"); }
#line 1492 "y.tab.c"
    break;

  case 39: /* expression: LPAREN expression RPAREN  */
#line 120 "parser.y"
                                      { (yyval.node_obj) = mknode((yyvsp[-1].node_obj), NULL, "expression in paren"); }
#line 1498 "y.tab.c"
    break;

  case 40: /* expression: IDENT  */
#line 122 "parser.y"
           {
               (yyval.node_obj) = mknode(NULL, NULL, yylval.node_type); 
           }
#line 1506 "y.tab.c"
    break;

  case 41: /* expression: NUMBER  */
#line 126 "parser.y"
           {
               (yyval.node_obj) = mknode(NULL, NULL, yylval.node_type); 
           }
#line 1514 "y.tab.c"
    break;

  case 42: /* expression: STR  */
#line 130 "parser.y"
           {
               (yyval.node_obj) = mknode(NULL, NULL, yylval.node_type); 
           }
#line 1522 "y.tab.c"
    break;

  case 50: /* arg_val: %empty  */
#line 144 "parser.y"
          {}
#line 1528 "y.tab.c"
    break;


#line 1532 "y.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturn;
#endif


/*-------------------------------------------------------.
| yyreturn -- parsing is finished, clean up and return.  |
`-------------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 188 "parser.y"


int main(void) {
    FILE *fp;
    fp = fopen("test.rog","r");
    yyin = fp;
    yyparse();

    fp = fopen("out.txt", "w");
    tree_free(head, fp);
    fclose(fp);

}

int yyerror(const char *s)
{
    fprintf(stderr,"%s\n",s);
}

int yywrap(){
    return 1;
}

struct node *mknode(struct node *left, struct node *right, char *token) {	
	struct node *newnode = (struct node *)malloc(sizeof(struct node));
    char *newstr = (char *)malloc(strlen(token)+1);
	strcpy(newstr, token);
	newnode->left = left;
	newnode->right = right;
	newnode->token = newstr;
	return newnode;
}

void tree_free(struct node *node, FILE *fp) {
    fprintf(fp, node->token);
    fprintf(fp, "    ");
    fprintf(fp, "%p", node);
    fprintf(fp, "    ");
    fprintf(fp, "%p", node->left);
    fprintf(fp, "    ");
    fprintf(fp, "%p", node->right);
    fprintf(fp, "\n");
    fflush(fp);
    printf(node->token);
    printf("\n");
    fflush(stdout);
    if (node->left){
        tree_free(node->left, fp);
    }
    if (node->right){
        tree_free(node->right, fp);
    }
}
