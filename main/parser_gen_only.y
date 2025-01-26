%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int yylex(void);
int yyerror(const char *);

extern FILE *yyin;
FILE *out;

extern int input_file_line_no;

int tempCounter = 0;
char *newTemp() {
    char *temp = (char*)malloc(16*sizeof(char));
    sprintf(temp, "%%t%d", tempCounter++);
    return temp;
}

%}

%union{
    char *number;
    char *string;
    char *id;
    char *type;
}

%token START_OF_FILE REMLIST ADDLIST PLUS MINUS TIMES DIVIDE RCURL SEMICOL COMMA EQL NEQ LSS GTR LEQ GEQ CALL DEF RTRN LOOP TO IF BYTE INT STRTYPE LPAREN RPAREN LBRACK RBRACK LCURL LISTTYPE VOIDTYPE ASSIGN CAPACITY LEN COMMENT MULTICOMMENT
%token <id> IDENT
%token <number> NUMBER
%token <string> STR

%type st program statement declarations function_inp arg_func func_dec function_block return variable_dec change_val comment flow_control range block step condition function_line function_call arg_val arg_func_type comp
%type <number> expression 
%type <type> datatype 
%type <string> value

%left IDENT
%right LBRACK
%left PLUS MINUS
%left TIMES DIVIDE
%right ASSIGN
%nonassoc EQL NEQ LSS GTR LEQ GEQ

%start st


%%

st : START_OF_FILE program 
	;

program : statement program 
	| statement 
	;

statement : declarations
	| expression
	| flow_control 
	| change_val
	| comment 
	;


declarations : func_dec 
	| variable_dec 
	;


comment : COMMENT
	| MULTICOMMENT 
	;

change_val : IDENT ASSIGN expression 
	;

func_dec : DEF arg_func_type IDENT LPAREN function_inp RPAREN 
LCURL function_block RCURL
	;

function_inp : arg_func
	| arg_func COMMA function_inp 
	| 
	;

arg_func : arg_func_datatype IDENT 
	;


arg_func_type : BYTE
	| INT
	| STR
	| VOIDTYPE
	;


arg_func_datatype : BYTE 
	| INT 
	| STRTYPE 
	;

function_block : function_line 
	| function_block function_line 
	;

function_line : statement 
	| return 
	;

return : RTRN expression 
	;

expression : expression PLUS expression { $$ = newTemp(); fprintf(out, "%s = add i32 %s, %s\n", $$, $1, $3); }
	| expression MINUS expression { $$ = newTemp(); fprintf(out, "%s = sub i32 %s, %s\n", $$, $1, $3); }
	| expression TIMES expression { $$ = newTemp(); fprintf(out, "%s = mul i32 %s, %s\n", $$, $1, $3); }
	| expression DIVIDE expression { $$ = newTemp(); fprintf(out, "%s = udiv i32 %s, %s\n", $$, $1, $3); }
	| LPAREN expression RPAREN { $$ = $2; }
    | value { $$ = (char*)malloc(16*sizeof(char)); snprintf($$, 16, "%%%s", $1); }
	;

value : IDENT { $$ = yylval.string; }
	| NUMBER { $$ = yylval.string; }
	| STR { $$ = yylval.string; }
	| function_call
	;

function_call : CALL IDENT LPAREN arg_val RPAREN
	| CALL CAPACITY LPAREN arg_val RPAREN
	| CALL LEN LPAREN arg_val RPAREN
	;

arg_val : expression 
	| arg_val COMMA expression 
	| 
	;


variable_dec : datatype IDENT ASSIGN expression {
             if (strcmp($1, "string") == 0){
                $1 = (char *)malloc(16*sizeof(char));
                snprintf($1, 16, "[i8 x %d]", strlen($4)+1);
                fprintf(out, "%%%s = alloca %s\n", $2, $1);
                fprintf(out, "store %s c%s, ptr %%%s\n", $1, $4, $2);
            } else{
            fprintf(out, "%%%s = alloca %s\n", $2, $1);
            fprintf(out, "store %s %s, ptr %%%s\n", $1, $4, $2);
            }
            }
	;

datatype : BYTE { $$ = "i8"; }
	| INT { $$ = "i32"; }
	| STRTYPE { $$ = "string"; }
	;


flow_control : LOOP LPAREN datatype IDENT SEMICOL range RPAREN block
	| IF LPAREN condition RPAREN block 
	;

range: expression TO expression 
	| expression TO expression SEMICOL step 
	;

step : expression 
	;

condition : expression comp expression 
	;

comp : EQL | NEQ | LSS | GTR | LEQ | GEQ
	;

block : LCURL program RCURL 
	;

%%

int yyerror(const char *s)
{
    fprintf(stderr,"%s on line: %d\n",s, input_file_line_no);
}

int yywrap(){
    return 1;
}

int main(void) {
    FILE *fp;
    fp = fopen("test.rog","r");
    yyin = fp;
    out = fopen("out_llvm.ll", "w");
    yyparse();
    fclose(fp);
    fclose(out);
}
