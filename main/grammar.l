whitespace         [ \t]
digit              [0-9]
letter             [A-Za-z]

%{
#include <string.h>
#include "parser.tab.h"

    int input_file_line_no = 1;
%}

%x COMMENTSTATE

%%

    /*identify online comments */
##[^[].* {  return COMMENT; } 

    /*.identify multiline comments */
"##[[" { BEGIN COMMENTSTATE; }

<COMMENTSTATE>"]]##" { BEGIN INITIAL; return MULTICOMMENT; }
<COMMENTSTATE>.* { }


"start-ROG" { return START_OF_FILE;  }

"+" { return PLUS; }
"-" { return MINUS; }
"*" { return TIMES; }
"/" { return DIVIDE; }
";" { return SEMICOL; }
"," { return COMMA; }
"=" { return ASSIGN; }
"==" { return EQL; }
"!=" { return NEQ; }
"<" { return LSS; }
">" { return GTR; }
"<=" { return LEQ; }
">=" { return GEQ; }
"->" { return TO; }

"(" { return LPAREN; }
")" { return RPAREN; }
"[" { return LBRACK; }
"]" { return RBRACK; }
"{" { return LCURL; }
"}" { return RCURL; }

"call" { return CALL; }
"func" { return DEF; }
"void" { return VOID; }
"return" { return RTRN; }
"loop" { return LOOP; }
"if" { return IF; }
"byte" { yylval.id = strdup(yytext); return BYTE; }
"int" { yylval.id = strdup(yytext); return INT; }
"str" { yylval.id = strdup(yytext); return STRTYPE; }
"arr" { yylval.id = strdup(yytext); return ARRTYPE; }
"len" { return LEN; }
"print" { return PRINT; }


[\n] {  input_file_line_no ++; }

whitespace

"-"?{digit}+ { yylval.id = strdup(yytext); return NUMBER; }

{letter}({letter}|"_"|"-"|{digit})* { yylval.id = strdup(yytext); return IDENT; }


    /* read in strings */ 
\"[^"]*\" { yylval.id = strdup(yytext); return STR; }

