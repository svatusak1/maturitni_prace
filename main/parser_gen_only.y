%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>


int yylex(void);
int yyerror(const char *);

extern FILE *yyin;
FILE *temp_out;
FILE *temp_hold;
FILE *out;

extern int input_file_line_no;

int tempCounter = 0;
char *newTemp() {
    char *temp = (char*)malloc(16*sizeof(char));
    sprintf(temp, "%%t%d", tempCounter++);
    return temp;
}

int strCount = 0;

void makeString(char*, int, char*);

char* ret_type;
int ifCounter = 0;

%}

%union{
    char *id;
}

%token START_OF_FILE REMLIST ADDLIST PLUS MINUS TIMES DIVIDE RCURL SEMICOL COMMA EQL NEQ LSS GTR LEQ GEQ CALL DEF RTRN LOOP TO IF LPAREN RPAREN LBRACK RBRACK LCURL LISTTYPE VOIDTYPE ASSIGN CAPACITY LEN COMMENT MULTICOMMENT
%token <id> IDENT NUMBER STR BYTE INT STRTYPE VOID

%type st program statement declarations func_dec variable_dec change_val comment flow_control range block step condition function_call function_line function_block arg_val function_inp arg_func arg_func_datatype return 
%type <id> exp expression datatype value func_datatype comp 

%left IDENT
%right LBRACK
%left PLUS MINUS
%left TIMES DIVIDE
%right ASSIGN
%nonassoc EQL NEQ LSS GTR LEQ GEQ

%start st


%%

st : START_OF_FILE { fprintf(out, "source_filename = \"Module\" \ntarget triple = \"x86_64-w64-mingw32\"\n\n"); } program
	;

program : statement program 
	| statement 
	;

statement : declarations
	| exp
	| flow_control 
	| change_val
	| comment 
	;


declarations : func_dec 
	| variable_dec 
    | string_dec
	;


string_dec : STRTYPE IDENT ASSIGN STR { makeString($2, strlen($4)-2, $4); }

comment : COMMENT
	| MULTICOMMENT 
	;

change_val : IDENT ASSIGN exp { fprintf(out, "%%%s = add i32 %s, 0\n", $1, $3); }
           // TODO add versions to variables to change them -- keep in symbol table
           ;

func_dec : DEF { temp_hold = temp_out; temp_out = out; fprintf(temp_out, "\ndefine "); }
         func_datatype { ret_type = $3; fprintf(out, "%s", $3); } IDENT LPAREN { fprintf(temp_out, " @%s(", $5); } function_inp RPAREN { fprintf(temp_out, "){\nentry:\n"); }
         LCURL function_block RCURL { fprintf(temp_out, "}\n\n"); temp_out = temp_hold; }
         ;

function_inp : arg_func
	| arg_func COMMA { fprintf(temp_out, ", "); } function_inp
	| { }
	;

arg_func : arg_func_datatype IDENT { 
        fprintf(temp_out, " %%%s", $2); }
        ;


func_datatype : BYTE { $$ = "i8"; }
	| INT { $$ = "i32"; }
//	| STRTYPE NUMBER { $$ = atoi($2); }
// TODO make string function return types
	| VOIDTYPE { $$ = "void"; }
	;


arg_func_datatype : BYTE { fprintf(temp_out, "i8"); }
	| INT { fprintf(temp_out, "i32"); }
//	| STRTYPE NUMBER { fprintf(temp_out, "[i8 x %d]", atoi($2)); }
// TODO function input also strings
	;

function_block : function_line 
	| function_block function_line
	;

function_line : statement 
	| return { fprintf(temp_out, "\n"); }
	;

return : RTRN expression { fprintf(temp_out, "ret %s %s", ret_type, $2); }
	;

exp : expression
    | function_call { }
    ;

expression : expression PLUS expression { $$ = newTemp(); fprintf(temp_out, "%s = add i32 %s, %s\n", $$, $1, $3); }
	| expression MINUS expression { $$ = newTemp(); fprintf(temp_out, "%s = sub i32 %s, %s\n", $$, $1, $3); }
	| expression TIMES expression { $$ = newTemp(); fprintf(temp_out, "%s = mul i32 %s, %s\n", $$, $1, $3); }
	| expression DIVIDE expression { $$ = newTemp(); fprintf(temp_out, "%s = udiv i32 %s, %s\n", $$, $1, $3); }
	| LPAREN expression RPAREN { $$ = $2; }
    | value
	;

value : IDENT { $$ = (char*)malloc(sizeof(char) * (strlen(yylval.id)+2)); snprintf($$, strlen(yylval.id)+1+1, "%%%s", yylval.id); }
// TODO if string use global @ else %
	| NUMBER { $$ = yylval.id; }
	;

function_call : CALL IDENT { fprintf(temp_out, "call ret_type @%s(", $2); } LPAREN arg_val RPAREN { fprintf(temp_out, ")\n"); }
	| CALL CAPACITY LPAREN arg_val RPAREN { }
	| CALL LEN LPAREN arg_val RPAREN { }
	;

arg_val : expression { fprintf(temp_out, "var_type %s", $1); }
	| arg_val COMMA expression { fprintf(temp_out, ", var_type %s", $3); }
	| { }
	;


variable_dec : datatype IDENT ASSIGN exp {
            fprintf(temp_out, "%%%s = alloca %s\n", $2, $1);
            fprintf(temp_out, "store %s %s, ptr %%%s\n", $1, $4, $2);
            }

            ;

datatype : BYTE { $$ = "i8"; }
	| INT { $$ = "i32"; }
	;


flow_control : LOOP LPAREN datatype IDENT SEMICOL range RPAREN block
	| IF LPAREN { fprintf(temp_out, "\n"); } condition RPAREN
    {
    fprintf(temp_out, "br i1 %%condition%d, label %%if%d, label %%continue%d\nif%d:\n", ifCounter, ifCounter, ifCounter, ifCounter);
    }
    block
    { fprintf(temp_out, "br i1 1, label %%continue%d, label %%entry\ncontinue%d:\n", ifCounter, ifCounter); 
    ifCounter ++;
    }
    ;

range: expression TO expression 
	| expression TO expression SEMICOL step 
	;

step : expression 
	;

condition : expression comp expression
          {
          fprintf(temp_out, "%%c1%d = load i32, ptr %s\n %%condition%d = icmp %s i32 %%c1%d, %s\n", ifCounter, $1, ifCounter, $2, ifCounter, $3);
          }
          //todo load if variable else not 
	;

comp : EQL { $$ = "eq"; }
     | NEQ { $$ = "neq"; }
     | GTR { $$ = "sgt"; }
     | LSS { $$ = "slt"; }
     | LEQ { $$ = "sle"; }
     | GEQ { $$ = "sge"; }
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
    temp_out = fopen("temp_llvm.ll", "w");
    yyparse();

    fprintf(out, "\ndefine i32 @main() {\nentry:\n");

    fclose(fp);
    fclose(out);
    fclose(temp_out);

    out = fopen("out_llvm.ll", "a");
    temp_out = fopen("temp_llvm.ll", "r");
    int c;
    while ((c = fgetc(temp_out)) != EOF)
    {
        fputc(c, out);
    }

    fprintf(out, "ret i32 0\n}");
    
    fclose(out);
    fclose(temp_out);
}

void makeString(char *ident, int size, char *str){

    fprintf(out, "@%s = internal constant [%d x i8] c%s\n", ident, size, str);

}
