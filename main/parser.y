%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int should_print = 1;
int arg_len = 0;

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

struct string {
    char *id;
    int len;
}string_lengths[10];
int strCount = 0;

char* func_ret_type;
int ifCounter = 0;
int loopCounter = 0;

struct loop_range {
    char *start;
    char *end;
    char *step;
};

struct loop_range range = {"0", "0", "1"};


char type[10];
void add(char, char*);
struct symbolDataType {
    char *data_type;
    char *id;
    char *symbol_type;
    int line_number;
    int version;
} symbol_table[1024];
int count_symbol_table = 0;

void insert_type(char*);

int search(char*);


struct arg_node {
    char *id;
    char *type;
    struct arg_node *next;
};

struct functionDataType {
    char *data_type;
    char *id;
    int line_number;
    struct arg_node node;

} function_table[50];
int count_function_table = 0;


%}

%union{
    char *id;
    char arguments[1024];
}

%token START_OF_FILE REMLIST ADDLIST PLUS MINUS TIMES DIVIDE RCURL SEMICOL COMMA EQL NEQ LSS GTR LEQ GEQ CALL DEF RTRN LOOP TO IF LPAREN RPAREN LBRACK RBRACK LCURL LISTTYPE ASSIGN CAPACITY LEN COMMENT MULTICOMMENT
%token <id> IDENT NUMBER STR BYTE INT STRTYPE

%type st program statement declarations func_dec variable_dec change_val comment flow_control range block step condition function_line function_block function_inp arg_func arg_func_datatype return 
%type <id> expression datatype value func_datatype comp function_call step
%type <arguments> arg_val


%left IDENT
%right LBRACK
%left PLUS MINUS
%left TIMES DIVIDE
%right ASSIGN
%nonassoc EQL NEQ LSS GTR LEQ GEQ

%start st


%%

st : START_OF_FILE { add('K', "file_begin"); fprintf(out, "source_filename = \"Module\" \ntarget triple = \"x86_64-w64-mingw32\"\n"); } program
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
    | string_dec
	;


string_dec : STRTYPE IDENT ASSIGN STR
           {
           int len = strlen($4)-2;
           char *str_type = (char *)malloc(7+len+1);
           snprintf(str_type, 7+len+1, "[%d x i8]", len);
           fprintf(temp_out, "%%%s = alloca %s\nstore [%d x i8] c%s, ptr %%%s\n", $2, str_type, len, $4, $2);
           insert_type(str_type);
           add('V', $2);
           string_lengths[strCount].id = $2;
           string_lengths[strCount].len = len;
           }

comment : COMMENT
	| MULTICOMMENT 
	;

change_val : IDENT ASSIGN {
           insert_type(symbol_table[search($1)].data_type);
           } expression {
           fprintf(temp_out, "store %s %s, ptr %%%s0\n", type, $4, $1);
           }
           ;

func_dec : DEF
         {
         add('K', "def");
         temp_hold = temp_out; temp_out = out; fprintf(temp_out, "\ndefine ");
         //TODO add to function table
         }
         func_datatype
         {
         func_ret_type = $3;
         fprintf(out, "%s", $3);
         }
         IDENT LPAREN
         {
         fprintf(temp_out, " @%s(", $5);
         add('F', $5);
         }
         function_inp RPAREN
         {
         fprintf(temp_out, "){\nentry:\n");
         }
         LCURL function_block RCURL { fprintf(temp_out, "}\n\n"); temp_out = temp_hold; }
         ;

function_inp : arg_func
	| arg_func COMMA { fprintf(temp_out, ", "); } function_inp
	| { }
	;

arg_func : arg_func_datatype IDENT { 
        fprintf(temp_out, " %%%s0", $2);
        add('I', $2);
        }
        ;


func_datatype : BYTE { $$ = "i8"; insert_type($$); }
	| INT { $$ = "i32"; insert_type($$); }
    //  TODO string type
	;


arg_func_datatype : BYTE { fprintf(temp_out, "ptr"); }
	| INT { fprintf(temp_out, "ptr"); }
//	| STRTYPE NUMBER { fprintf(temp_out, "[i8 x %d]", atoi($2)); }
// TODO function input also strings
	;

function_block : function_line 
	| function_block function_line
	;

function_line : statement 
	| return { fprintf(temp_out, "\n"); }
	;

return : RTRN expression { add('K', "return"); 
       fprintf(temp_out, "ret %s %s", func_ret_type, $2); }
	;


expression : expression PLUS expression
           {
           $$ = newTemp(); fprintf(temp_out, "%s = add %s %s, %s\n", $$, type, $1, $3);
           }
	| expression MINUS expression { $$ = newTemp(); fprintf(temp_out, "%s = sub %s %s, %s\n", $$, type, $1, $3); }
	| expression TIMES expression { $$ = newTemp(); fprintf(temp_out, "%s = mul %s %s, %s\n", $$, type, $1, $3); }
	| expression DIVIDE expression { $$ = newTemp(); fprintf(temp_out, "%s = udiv %s %s, %s\n", $$, type, $1, $3); }
	| LPAREN expression RPAREN { $$ = $2; }
    | value
	;

value : IDENT
      {
      int index = search($1);
      if ( index < 0){
        char msg [1024];
        snprintf(msg, 18+1+strlen($1), "unknown variable- %s", $1);
        yyerror(msg);
        }
      char version[512];
      itoa(symbol_table[index].version, version, 10);
      $$ = (char*)malloc(sizeof(char) * (strlen(yylval.id)+ 1 + strlen(version) + 1));
      snprintf($$, 1+strlen(yylval.id)+1+strlen(version)+1, "%%%s.%s", yylval.id, version);
      if (should_print){
          fprintf(temp_out, "%%%s.%d = load %s, ptr %%%s0\n", $1, symbol_table[index].version, symbol_table[index].data_type, $1, $1);
      }
      symbol_table[index].version++;
      }
	| NUMBER { $$ = yylval.id; }
      | function_call { $$ = newTemp(); fprintf(temp_out, "%s = %s\n", $$, $1); }
	;

function_call : CALL IDENT
              LPAREN arg_val RPAREN 
              {
              add('K', "call");
              int index = search($2);
              char *func_ret_type;
              if (index >=0){
                  func_ret_type = symbol_table[index].data_type; 
              }
              if (!func_ret_type){
                    yyerror("variable not declared");
                }
              $$ = (char*)malloc((5+strlen(func_ret_type)+2+strlen($2)+1+strlen($4)+1+1)*sizeof(char));
              snprintf($$, 5+strlen(func_ret_type)+2+strlen($2)+1+strlen($4)+1+1, "call %s @%s(%s)", func_ret_type, $2, $4);
              }

	| CALL CAPACITY LPAREN arg_val RPAREN { add('K', "capacity-func"); }
	| CALL LEN LPAREN arg_val RPAREN { add('K', "len-func"); }
	;

arg_val : expression
        {
        if (isdigit($1[0])){
            // TODO make it as the function requires
            insert_type("i32");
        } else{
            int index = search($1+1);
            if (index < 0){
                yyerror("unknown variable");
            }
            insert_type(symbol_table[index].data_type);
        }
        snprintf($$, strlen($1)+strlen(type)+2, "%s %s", type, $1);
        arg_len = strlen($1)+strlen(type)+1;
        }
        | arg_val COMMA expression
        {
        if (isdigit($3[0])){
            // TODO make it as the function requires
            insert_type("i32");
        } else{
            int i = 0;
            while (i < strlen($3)){
                if ('.' == $3[i]){
                    $3[i] = '\0';
                    break;
                }
                i++;
            }
            int index = search($3+1);
            $3[i] = '.';
            if (index < 0){
                yyerror("unknown variable");
            }
            insert_type(symbol_table[index].data_type);
        }
        snprintf($$ + arg_len, strlen($3)+strlen(type)+4, ", %s %s", type, $3);
        arg_len += strlen($3)+strlen(type)+3;
        }
        | { }
        ;


variable_dec : datatype IDENT ASSIGN expression {
             add('V', $2);
            fprintf(temp_out, "%%%s0 = alloca %s\n", $2, $1);
            fprintf(temp_out, "store %s %s, ptr %%%s0\n", $1, $4, $2);
            }

            ;

datatype : BYTE { $$ = "i8"; insert_type("i8"); }
	| INT { $$ = "i32"; insert_type("i32"); }
	;


flow_control : LOOP {
             fprintf(temp_out, "\nbr label %%entry_loop%d\n", loopCounter);
             fprintf(temp_out, "entry_loop%d:\n", loopCounter);
             add('K', "loop");
             }
             LPAREN datatype IDENT
             SEMICOL range RPAREN
{
    fprintf(temp_out, "%%%s0 = alloca %s\n", $5, type);
    fprintf(temp_out, "store %s %s, ptr %%%s0\n", type, range.start, $5);
    add('V', $5);
    fprintf(temp_out, "%%max = add i32 0, %s\n", range.end);
    fprintf(temp_out, "br label %%loop_start%d\n", loopCounter);
    fprintf(temp_out, "loop_start%d:\n", loopCounter);
    fprintf(temp_out, "%%i.check = load %s, ptr %%%s0\n", type, $5);
    fprintf(temp_out, "%%done%d = icmp eq i32 %%i.check, %%max\n", loopCounter);
    fprintf(temp_out, "br i1 %%done%d, label %%continue_loop%d, label %%loop%d\n", loopCounter, loopCounter, loopCounter);
    fprintf(temp_out, "loop%d:\n", loopCounter);
}
             block
             {
             fprintf(temp_out, "br label %%loop_start%d\n", loopCounter);
             fprintf(temp_out, "continue_loop%d:\n", loopCounter);
             loopCounter++;
             }
	| IF LPAREN
    {
    should_print = 0;
    add('K', "if");
    fprintf(temp_out, "\n");
    }
    condition RPAREN
    {
    fprintf(temp_out, "br i1 %%condition%d, label %%if%d, label %%continue_if%d\nif%d:\n", ifCounter, ifCounter, ifCounter, ifCounter);
    should_print = 1;
    }
    block
    { fprintf(temp_out, "br label %%continue_if%d\ncontinue_if%d:\n\n", ifCounter, ifCounter); 
    ifCounter ++;
    }
    ;

range: expression TO expression { range.start = $1; range.end = $3; }
	| expression TO expression SEMICOL step { range.start = $1; range.end = $3; range.step = $5; }
	;

step : expression 
	;

condition : expression comp expression
          {
            int i = 0;
            while (i < strlen($1)){
                if ('.' == $1[i]){
                    $1[i] = '\0';
                    break;
                }
                i++;
            }

            i = 0;
            while (i < strlen($3)){
                if ('.' == $3[i]){
                    $3[i] = '\0';
                    break;
                }
                i++;
            }
          fprintf(temp_out, "%%c%d = load i32, ptr %s0\n", ifCounter, $1);
          fprintf(temp_out, "%%condition%d = icmp %s i32 %%c%d, %s\n", ifCounter, $2, ifCounter, $3);
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
    out = fopen("out.ll", "w");
    temp_out = fopen("temp_llvm.ll", "w");
    yyparse();

    fprintf(out, "\ndefine i32 @main() {\nentry:\n");

    fclose(fp);
    fclose(out);
    fclose(temp_out);

    out = fopen("out.ll", "a");
    temp_out = fopen("temp_llvm.ll", "r");
    int c;
    while ((c = fgetc(temp_out)) != EOF)
    {
        fputc(c, out);
    }

    fprintf(out, "ret i32 0\n}\n");
    
    fclose(out);
    fclose(temp_out);

    printf("\n\n");
    printf("\nSYMBOL || DATATYPE || TYPE || LINE NUMBER\n");
    printf("__________________________________________________\n\n");
    int i;
    for(i=0; i<count_symbol_table; i++) {
        printf("%s\t%s\t%s \t%d\n", symbol_table[i].id, symbol_table[i].data_type, symbol_table[i].symbol_type, symbol_table[i].line_number);
    }
    printf("\n\n");


}

void makeString(char *ident, int size, char *str){

    fprintf(out, "@%s = internal constant [%d x i8] c%s\n", ident, size, str);

}


void insert_type(char *type_to_insert){
    int ret = snprintf(type, 10, "%s", type_to_insert);
    if (ret < strlen(type)){
        yyerror("error inserting type");
    }
}


void add(char c, char *id){
    
    int found = search(id);
    if (c == 'K'){
        found = -1;
    }

    if (found == -1){
        symbol_table[count_symbol_table].id = strdup(id);
        symbol_table[count_symbol_table].line_number = input_file_line_no;
        symbol_table[count_symbol_table].version = 0;
        switch (c){
        /*
        K keyword
        C consctant
        V variable
        F function dec
        I function input variable
        */
            case 'K':
                symbol_table[count_symbol_table].data_type = "N/A";
                symbol_table[count_symbol_table].symbol_type = "Keyword";
                break;

            case 'C':
                symbol_table[count_symbol_table].data_type = "CONSTAT";
                symbol_table[count_symbol_table].symbol_type = "Constant";
                break;

            case 'V':
                symbol_table[count_symbol_table].data_type = strdup(type);
                symbol_table[count_symbol_table].symbol_type = "Variable";
                break;

            case 'I':
                symbol_table[count_symbol_table].data_type = strdup(type);
                symbol_table[count_symbol_table].symbol_type = "Function_input";
                break;

            case 'F':
                symbol_table[count_symbol_table].data_type = strdup(type);
                symbol_table[count_symbol_table].symbol_type = "Funtion dec";
                break;

            default:
                yyerror("symbol not found");
        }
        count_symbol_table++;
    }
    if (found >= 0 && c == 'V'){
        yyerror("Multiple variable declarations aren't allowed");
    }
    if (found >= 0 && c == 'F'){
        yyerror("Multiple fucntion declarations aren't allowed");
    }

}

int search(char *id){
    int i;
    for (i = count_symbol_table-1; i>= 0; i--){
        if (strcmp(symbol_table[i].id, id) == 0){
            return i;
        }
    }
    return -1;
}
