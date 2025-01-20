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


"start-ROG" {  return START_OF_FILE;  }

"+" {  strcpy(yylval.end_node, yytext); return PLUS; }
"-" {  strcpy(yylval.end_node, yytext); return MINUS; }
"*" {  strcpy(yylval.end_node, yytext); return TIMES; }
"/" {  strcpy(yylval.end_node, yytext); return DIVIDE; }
";" {  strcpy(yylval.end_node, yytext); return SEMICOL; }
"," {  strcpy(yylval.end_node, yytext); return COMMA; }
"=" {  strcpy(yylval.end_node, yytext); return ASSIGN; }
"==" {  strcpy(yylval.end_node, yytext); return EQL; }
"!=" {  strcpy(yylval.end_node, yytext); return NEQ; }
"<" {  strcpy(yylval.end_node, yytext); return LSS; }
">" {  strcpy(yylval.end_node, yytext); return GTR; }
"<=" {  strcpy(yylval.end_node, yytext); return LEQ; }
">=" {  strcpy(yylval.end_node, yytext); return GEQ; }
"--" {  strcpy(yylval.end_node, yytext); return REMLIST; }
"++" {  strcpy(yylval.end_node, yytext); return ADDLIST; }
"->" {  strcpy(yylval.end_node, yytext); return TO; }

"(" {  strcpy(yylval.end_node, yytext); return LPAREN; }
")" {  strcpy(yylval.end_node, yytext); return RPAREN; }
"[" {  strcpy(yylval.end_node, yytext); return LBRACK; }
"]" {  strcpy(yylval.end_node, yytext); return RBRACK; }
"{" {  strcpy(yylval.end_node, yytext); return LCURL; }
"}" {  strcpy(yylval.end_node, yytext); return RCURL; }

"call" {  strcpy(yylval.end_node, yytext); return CALL; }
"func" {  strcpy(yylval.end_node, yytext); return DEF; }
"return" {  strcpy(yylval.end_node, yytext); return RTRN; }
"loop" {  strcpy(yylval.end_node, yytext); return LOOP; }
"if" {  strcpy(yylval.end_node, yytext); return IF; }
"byte" {  strcpy(yylval.end_node, yytext); return BYTE; }
"int" {  strcpy(yylval.end_node, yytext); return INT; }
"str" {  strcpy(yylval.end_node, yytext); return STRTYPE; }
"void" {  strcpy(yylval.end_node, yytext); return VOIDTYPE; }
"list" {  strcpy(yylval.end_node, yytext); return LISTTYPE; }
"capacity" {  strcpy(yylval.end_node, yytext); return CAPACITY; }
"len" {  strcpy(yylval.end_node, yytext); return LEN; }


[\n] { input_file_line_no ++; }
whitespace

{letter}({letter}|"_"|{digit})* {  strcpy(yylval.end_node, yytext); return IDENT; }


"-"?{digit}+ {  strcpy(yylval.end_node, yytext); return NUMBER; }

    /* read in strings */ 
\"[^"]*\" {   strcpy(yylval.end_node, yytext); return STR; }
