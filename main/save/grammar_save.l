whitespace         [ \t]
digit              [0-9]
letter             [A-Za-z]

%{
#include <string.h>
#include "y.tab.h"

    int input_line_no = 1;
%}

%x COMMENTSTATE

%%

    /*.nameentify online comments */
##[^[].* {  return COMMENT; } 

    /*.nameentify multiline comments */
"##[[" { BEGIN COMMENTSTATE;
          return MULTICOMMENT; }

<COMMENTSTATE>[^#\]]+ { /* ignore comment */}
<COMMENTSTATE>"]]##" { BEGIN INITIAL; }
<COMMENTSTATE>[#\]] { /* rest */}


"start-ROG" {  return START_OF_FILE;  }

"+" {  yylval.node_type = strdup(yytext); return PLUS; }
"-" {  yylval.node_type = strdup(yytext); return MINUS; }
"*" {  yylval.node_type = strdup(yytext); return TIMES; }
"/" {  yylval.node_type = strdup(yytext); return DIVIDE; }
";" {  yylval.node_type = strdup(yytext); return SEMICOL; }
"," {  yylval.node_type = strdup(yytext); return COMMA; }
"=" {  yylval.node_type = strdup(yytext); return ASSIGN; }
"==" {  yylval.node_type = strdup(yytext); return EQL; }
"!=" {  yylval.node_type = strdup(yytext); return NEQ; }
"<" {  yylval.node_type = strdup(yytext); return LSS; }
">" {  yylval.node_type = strdup(yytext); return GTR; }
"<=" {  yylval.node_type = strdup(yytext); return LEQ; }
">=" {  yylval.node_type = strdup(yytext); return GEQ; }
"--" {  yylval.node_type = strdup(yytext); return REMLIST; }
"++" {  yylval.node_type = strdup(yytext); return ADDLIST; }
"->" {  yylval.node_type = strdup(yytext); return TO; }

"(" {  yylval.node_type = strdup(yytext); return LPAREN; }
")" {  yylval.node_type = strdup(yytext); return RPAREN; }
"[" {  yylval.node_type = strdup(yytext); return LBRACK; }
"]" {  yylval.node_type = strdup(yytext); return RBRACK; }
"{" {  yylval.node_type = strdup(yytext); return LCURL; }
"}" {  yylval.node_type = strdup(yytext); return RCURL; }

"call" { yylval.node_type = strdup(yytext); return CALL; }
"func" {  yylval.node_type = strdup(yytext); return DEF; }
"return" {  yylval.node_type = strdup(yytext); return RTRN; }
"loop" {  yylval.node_type = strdup(yytext); return LOOP; }
"if" {  yylval.node_type = strdup(yytext); return IF; }
"byte" {  yylval.node_type = strdup(yytext); return BYTE; }
"int" {  yylval.node_type = strdup(yytext); return INT; }
"str" {  yylval.node_type = strdup(yytext); return STRTYPE; }
"void" {  yylval.node_type = strdup(yytext); return VOIDTYPE; }
"list" {  yylval.node_type = strdup(yytext); return LISTTYPE; }
"capacity" {  yylval.node_type = strdup(yytext); return CAPACITY; }
"len" {  yylval.node_type = strdup(yytext); return LEN; }



[\n] { input_line_no ++; }


whitespace

{letter}({letter}|"_")* {
    yylval.node_type = strdup(yytext);
    return IDENT; }

"-"?{digit}+ { 
    yylval.node_type = strdup(yytext);
    return NUMBER; }

    /* read in strings */ 
\"[^"]*\" {  
    yytext = memmove(yytext, yytext+1, strlen(yytext));
    yytext[strlen(yytext)-1] = '\0';

    yylval.node_type = strdup(yytext);
    return STR; }

