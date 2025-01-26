whitespace         [ \t]
digit              [0-9]
letter             [A-Za-z]

%{
#include <string.h>
#include "y.tab.h"

    int input_file_line_no = 1;
%}

%x COMMENTSTATE

%%

    /*identify online comments */
##[^[].* {  return COMMENT; } 

    /*.identify multiline comments */
"##[[" { BEGIN COMMENTSTATE;
          return MULTICOMMENT; }

<COMMENTSTATE>[^#\]]+ { /* ignore comment */}
<COMMENTSTATE>"]]##" { BEGIN INITIAL; }
<COMMENTSTATE>[#\]] { /* rest */}


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
"return" { return RTRN; }
"loop" { return LOOP; }
"if" { return IF; }
"byte" { yylval.type = strdup(yytext); return BYTE; }
"int" { yylval.type = strdup(yytext); return INT; }
"str" { yylval.type = strdup(yytext); return STRTYPE; }
"void" { yylval.type = strdup(yytext); return VOIDTYPE; }
"list" { yylval.type = strdup(yytext); return LISTTYPE; }
"capacity" { return CAPACITY; }
"len" { return LEN; }


[\n] {  input_file_line_no ++; }

whitespace

{letter}({letter}|"_"|{digit})* { yylval.id = strdup(yytext); return IDENT; }


"-"?{digit}+ { yylval.number = strdup(yytext); return NUMBER; }

    /* read in strings */ 
\"[^"]*\" { yylval.string = strdup(yytext); return STR; }
