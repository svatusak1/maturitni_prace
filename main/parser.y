// TODO static list type

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void remove_after_dot(char* string);
void insert_str(char *strA, char *strB, int index, char *strC);

void unknown_var(char *);

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
}string_table[10];
int count_str = 0;
int str_search(char *);
int temp_strCount = 0;

int ifCounter = -1;
int loopCounter = 0;

struct loop_range {
    char *start;
    char *start_type;
    char *end;
    char *end_type;
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
    char *data_type;
    struct arg_node *next;
};

struct functionDataType {

    char *data_type;
    char *id;
    int line_number;
    struct arg_node *head;

} function_table[50];
int count_function_table = 0;

struct arg_node *current_arg_node;

int func_search(char *);
char* func_ret_type;
int in_function = 0;

char string_hold[1024] = "";

void assigne_types(char *func, char *types);


struct Stack{
    int value;
    struct Stack* next;
};

struct Stack* IfHead = NULL;


void add_if_stack(int value);
void pop_if_stack();
int get_top_if_stack();

struct Stack* ForHead = NULL;

void add_for_stack(int value);
void pop_for_stack();
int get_top_for_stack();

struct Stack* ArgHead = NULL;

void add_arg_stack(int value);
int pop_arg_stack();
int get_top_arg_stack();

void free_head(struct Stack*);

%}

%union{
    char *id;
    char arguments[1024];
    struct arg_node *input_node;
}

%token START_OF_FILE REMLIST ADDLIST PLUS MINUS TIMES DIVIDE RCURL SEMICOL COMMA EQL NEQ LSS GTR LEQ GEQ CALL DEF RTRN LOOP TO IF LPAREN RPAREN LBRACK RBRACK LCURL LISTTYPE ASSIGN CAPACITY LEN COMMENT MULTICOMMENT PRINT
%token <id> IDENT NUMBER STR BYTE INT STRTYPE

%type st program statement declarations func_dec variable_dec change_val comment flow_control range block step condition function_line function_block arg_func_datatype return 
%type <id> expression datatype value func_datatype comp function_call step
%type <arguments> arg_val
%type <input_node> func_inp arg_func


%left IDENT
%right LBRACK
%left PLUS MINUS
%left TIMES DIVIDE
%right ASSIGN
%nonassoc EQL NEQ LSS GTR LEQ GEQ CALL

%start st


%%

st : START_OF_FILE { add('K', "file_begin"); fprintf(out, "source_filename = \"Module\" \ntarget triple = \"x86_64-w64-windows-gnu\"\n\n"); }
   program
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
           int len = strlen($4)-2+1;

           char *str_type = (char *)malloc(7+len+1);
           snprintf(str_type, 7+len+1, "[%d x i8]", len);
           insert_type(str_type);
           add('V', $2);
           free(str_type);

           string_table[count_str].id = $2;
           string_table[count_str].len = len;
           count_str++;

           char res[512];

           int value = len;
           int l=1;
           while(value){ l++; value/=10; }
           int res_len = 1+strlen($2)+22+l+8+strlen($4)+4+1;

           $4[strlen($4)-1] = '\0';
           snprintf(res, res_len, "@%s = private constant [%d x i8] c%s\\00\"\n", $2, len, $4);

           if (in_function){
            strcat(string_hold, res);
           } else{
            fprintf(out, res);
            }
           }

comment : COMMENT
	| MULTICOMMENT 
	;

change_val : IDENT ASSIGN {
           insert_type(symbol_table[search($1)].data_type);
           } expression {
           fprintf(temp_out, "store %s %s, ptr %%%s0\n", type, $4, $1);
           free($4);
           }
           ;

func_dec : DEF
         {
         add('K', "def");
         temp_hold = temp_out; temp_out = out; fprintf(temp_out, "\ndefine ");
         function_table[count_function_table].line_number = input_file_line_no;
         in_function = 1;
         }
         func_datatype
         {
         func_ret_type = $3;
         fprintf(temp_out, "%s", $3);
         }
         IDENT LPAREN
         {
         function_table[count_function_table].id = $5;
         fprintf(temp_out, " @%s(", $5);
         add('F', $5);
         }
         func_inp RPAREN
         {
         function_table[count_function_table].id = $5;
         function_table[count_function_table].data_type = $3;
         function_table[count_function_table].head = $8;
         fprintf(temp_out, "){\nentry:\n");
         
         struct arg_node *node = function_table[count_function_table].head;
         while(node){
             fprintf(temp_out, "%%%s0 = alloca %s\n", node->id, node->data_type);
             fprintf(temp_out, "store i32 %%%s, ptr %%%s0\n", node->id, node->id);
             node = node->next;
        }
            
         count_function_table++;
         }
         LCURL function_block RCURL { fprintf(temp_out, "}\n\n"); temp_out = temp_hold; in_function = 0;
         fprintf(out, string_hold);
         }
         ;

func_inp : arg_func
	| func_inp { fprintf(temp_out, ", "); } COMMA arg_func
    {
    $1->next = $4;
    $$ = $1;
    }
	| { }
	;

arg_func : arg_func_datatype IDENT { 
        fprintf(temp_out, " %%%s", $2);
        add('I', $2);
         $$ = (struct arg_node*)malloc(sizeof(struct arg_node));
         $$->id = $2;
         $$->data_type = type;
         $$->next = NULL;
        }
        ;


func_datatype : BYTE { $$ = "i8"; insert_type($$); }
	| INT { $$ = "i32"; insert_type($$); }
	;


arg_func_datatype : BYTE { insert_type("i8"); fprintf(temp_out, "i8"); }
	| INT { insert_type("i32"); fprintf(temp_out, "i32"); }
	;

function_block : function_line 
	| function_block function_line
	;

function_line : statement 
	| return { fprintf(temp_out, "\n"); }
	;

return : RTRN expression
       {
       add('K', "return"); 
       fprintf(temp_out, "ret %s %s", func_ret_type, $2);
       free($2);
       }
       ;


expression : expression PLUS expression
           {
           $$ = newTemp(); fprintf(temp_out, "%s = add %s %s, %s\n", $$, type, $1, $3);
           range.start_type = type;
           free($1);
           free($3);
           }
	       
		   | expression MINUS expression
	       {
	       $$ = newTemp(); fprintf(temp_out, "%s = sub %s %s, %s\n", $$, type, $1, $3); range.start_type = type;
           free($1);
           free($3);
	       }
	       
		   | expression TIMES expression
	       {
	       $$ = newTemp(); fprintf(temp_out, "%s = mul %s %s, %s\n", $$, type, $1, $3); range.start_type = type;
           free($1);
           free($3);
	       }
	       
		   | expression DIVIDE expression
	       {
	       $$ = newTemp(); fprintf(temp_out, "%s = udiv %s %s, %s\n", $$, type, $1, $3); range.start_type = type;
           free($1);
           free($3);
           }
	       
		   | LPAREN expression RPAREN { $$ = $2; }
           
		   | value { $$ = $1; range.start_type = type; }
	       ;

value : IDENT
      {
      int index = search($1);
      if ( index < 0){
        unknown_var($1);
    } else {
      char version[512];
      itoa(symbol_table[index].version, version, 10);
      $$ = (char*)malloc(sizeof(char) * (strlen(yylval.id)+ 1 + strlen(version) + 1));
      snprintf($$, 1+strlen(yylval.id)+1+strlen(version)+1, "%%%s.%s", yylval.id, version);
      int str_index = str_search($1);
      if (str_index < 0){
          fprintf(temp_out, "%s = load %s, ptr %%%s0\n", $$, symbol_table[index].data_type, $1, $1);
          symbol_table[index].version++;
          snprintf(type, strlen(symbol_table[index].data_type)+1, symbol_table[index].data_type);
        }
      }
      }
	| NUMBER { $$ = yylval.id; }
      | function_call { $$ = newTemp(); fprintf(temp_out, "%s = %s\n", $$, $1); }
	;

function_call : CALL IDENT
              LPAREN
              arg_val RPAREN 
              {
              assigne_types($2, $4);
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
              pop_arg_stack();
            }

	| CALL LEN LPAREN IDENT RPAREN
    {
    add('K', "len-func");
    int index = str_search($4);
    if (index >= 0){
        char res[32];
        snprintf(res, 11+10+1, "add i32 0, %d", string_table[index].len-1);
        $$ = res;
    } else{
        unknown_var($4);
    }
    }
    | CALL PRINT LPAREN expression RPAREN 
    {
    char res[128];
    if ($4[0] == '%'){
        int i = 0;
        while ($4[i] != '.' && i < strlen($4)){
            i++;
        }
        if (i < strlen($4)){
            $4[i] = '\0';
            $4++;

            if (str_search($4) >= 0){
                snprintf(res, 30+strlen($4)+45+1, "call i32 @__mingw_printf(ptr @%s)\ncall i32 @__mingw_printf(ptr @newline__)\n", $4);
            } else{
                int index = search($4);
                if (index >= 0){
                    char *data_type = symbol_table[index].data_type;
                     $$ = newTemp();
                    fprintf(temp_out, "%s = load %s, ptr %%%s0\n", $$, data_type, $4);
                     if (strcmp(data_type, "i32") != 0){
                        char *tmp_var = newTemp();
                        fprintf(temp_out, "%s = sext %s %s to i32\n", tmp_var, data_type, $$);
                        $$ = tmp_var;
                    }
                     snprintf(res, 47+strlen($$)+1, "call i32 @__mingw_printf(ptr @num_str__, i32 %s)\n", $$);
                } else{
                    unknown_var($4);
                }
                temp_strCount++;
            }
            $4--;
        } else{
             snprintf(res, 47+strlen($$)+1, "call i32 @__mingw_printf(ptr @num_str__, i32 %s)\n", $4);
        }
    } else if (isdigit($4[0]) != 0){
        snprintf(res, 1+20+21+20+2+9+strlen($4)+2, "@%d = private constant [%d x i8] c\"%s\\0A\\00\"\n", temp_strCount, strlen($4)+2, $4);
       if (in_function){
        strcat(string_hold, res);
       } else{
        fprintf(out, res);
        }
        snprintf(res, 30+10+2+1, "call i32 @__mingw_printf(ptr @%d)\n", temp_strCount);
        temp_strCount++;
    }
    $$ = res;
    free($4);
    }
	;

arg_val : expression
        {
            snprintf($$, 1 + strlen($1)+1, " %s", $1);
            add_arg_stack(strlen($1)+1);
            free($1);
        }
        | arg_val COMMA expression
        {
        int arg_len = pop_arg_stack();
        int len = 2+strlen($3)+1;
        snprintf($$+arg_len, len, ", %s", $3);
        add_arg_stack(arg_len+len-1);
        free($3);
        }
        | {}
        ;


variable_dec : datatype IDENT ASSIGN expression {
             add('V', $2);
            fprintf(temp_out, "%%%s0 = alloca %s\n", $2, $1);
            fprintf(temp_out, "store %s %s, ptr %%%s0\n", $1, $4, $2);
            free($4);
            }

            ;

datatype : BYTE { $$ = "i8"; insert_type("i8"); }
	| INT { $$ = "i32"; insert_type("i32"); }
	;


flow_control : LOOP {
             loopCounter++;
             add_for_stack(loopCounter);
             fprintf(temp_out, "\nbr label %%entry_loop%d\n", get_top_for_stack());
             fprintf(temp_out, "entry_loop%d:\n", get_top_for_stack());
             add('K', "loop");
             }
             LPAREN datatype IDENT
             SEMICOL range RPAREN
{
    fprintf(temp_out, "%%%s0 = alloca %s\n", $5, type);
    add('V', $5);
    fprintf(temp_out, "store %s %s, ptr %%%s0\n", type, range.start, $5);
    fprintf(temp_out, "%%loop_var_comp__ = load %s, ptr %%%s0\n", type, $5);
    fprintf(temp_out, "%%max%d = add i32 0, %s\n", get_top_for_stack(), range.end);
    fprintf(temp_out, "%%condition_for%d = icmp sgt %s %%max%d, %%loop_var_comp__\n", get_top_for_stack(), type, get_top_for_stack());
    fprintf(temp_out, "br label %%loop_start%d\n", get_top_for_stack());

    fprintf(temp_out, "loop_start%d:\n", get_top_for_stack());
    fprintf(temp_out, "%%i.check%d = load %s, ptr %%%s0\n", get_top_for_stack(), type, $5);
    fprintf(temp_out, "br i1 %%condition_for%d, label %%sgt1%d__, label %%slt1%d__\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());

    fprintf(temp_out, "sgt1%d__:\n", get_top_for_stack());
    fprintf(temp_out, "%%done_sgt%d = icmp sgt i32 %%i.check%d, %%max%d\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());
    fprintf(temp_out, "br i1 %%done_sgt%d, label %%continue_loop%d, label %%loop%d\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());

    fprintf(temp_out, "slt1%d__:\n", get_top_for_stack());
    fprintf(temp_out, "%%done_slt%d = icmp slt i32 %%i.check%d, %%max%d\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());
    fprintf(temp_out, "br i1 %%done_slt%d, label %%continue_loop%d, label %%loop%d\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());

    fprintf(temp_out, "loop%d:\n", get_top_for_stack());
}
             block
             {
             fprintf(temp_out, "\n%%loop_var%d__ = load i32, ptr %%%s0\n", get_top_for_stack(), $5);
             fprintf(temp_out, "br i1 %%condition_for%d, label %%sgt2%d__, label %%slt2%d__\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());
             
             fprintf(temp_out, "sgt2%d__:\n", get_top_for_stack());
             fprintf(temp_out, "%%new_loop_var_sgt%d__ = add i32 %s, %%loop_var%d__\n", get_top_for_stack(), range.step, get_top_for_stack());
             fprintf(temp_out, "store i32 %%new_loop_var_sgt%d__, ptr %%%s0\n\n", get_top_for_stack(), $5);
             fprintf(temp_out, "br label %%loop_start%d\n", get_top_for_stack());

             fprintf(temp_out, "slt2%d__:\n", get_top_for_stack());
             fprintf(temp_out, "%%new_loop_var_slt%d__ = add i32 -%s, %%loop_var%d__\n", get_top_for_stack(), range.step, get_top_for_stack());
             fprintf(temp_out, "store i32 %%new_loop_var_slt%d__, ptr %%%s0\n\n", get_top_for_stack(), $5);
             fprintf(temp_out, "br label %%loop_start%d\n", get_top_for_stack());

             fprintf(temp_out, "continue_loop%d:\n\n", get_top_for_stack());
             pop_for_stack();
             }
	| IF LPAREN
    {
    ifCounter ++;
    add('K', "if");
    add_if_stack(ifCounter);
    }
    condition RPAREN
    {
    fprintf(temp_out, "br i1 %%condition%d, label %%if%d, label %%continue_if%d\nif%d:\n", get_top_if_stack(), get_top_if_stack(), get_top_if_stack(), get_top_if_stack());
    }
    block
    { fprintf(temp_out, "br label %%continue_if%d\ncontinue_if%d:\n\n", get_top_if_stack(), get_top_if_stack()); 
    pop_if_stack();
    }
    ;

range : expression TO expression { range.start = $1; range.end = $3; range.end_type = type; free($1); free($3); }
      | expression TO expression SEMICOL step { range.start = $1; range.end = $3; range.step = $5; free($1); free($3); }
      ;

step : expression
     {
     if ($1[0] == '-'){
         $1++;
     }
     $$ = $1;
     }
     ;

condition : expression comp expression
          {
          fprintf(temp_out, "%%condition%d = icmp %s i32 %s, %s\n", get_top_if_stack(), $2, $1, $3);
          }
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

    fprintf(out, "@newline__ = private constant [2 x i8] c\"\\0A\\00\"\n");
    fprintf(out, "@num_str__ = private constant [4 x i8] c\"%%d\\0A\\00\"\n");
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
    fprintf(out, "\ndeclare i32 @__mingw_printf(ptr noundef, ...)\n");
    
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


    printf("\n\nFunctions:");
    printf("\nNAME || RETURN_TYPE || ARGUMENTS || LINE NUMBER\n");
    printf("__________________________________________________\n\n");
    for(i=0; i<count_function_table; i++) {
        printf("%s\t%s\t", function_table[i].id, function_table[i].data_type);
        struct arg_node *node = function_table[i].head;
        printf("(");
        if (node){
            printf("%s %s", node->data_type, node->id);
            node = node->next;
        }
        while(node){
            printf(", %s %s", node->data_type, node->id);
            node = node->next;
        }
        printf(")");
        printf("\t%d\n", function_table[i].line_number);
    }
    printf("\n\n");

    printf("\n\nStrings:");
    printf("\nNAME || LEN\n");
    for (i = 0; i <count_str; i++){
        printf("%s\t%d\n", string_table[i].id, string_table[i].len);
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


int func_search(char *id){
    int i;
    for (i = count_function_table-1; i>= 0; i--){
        if (strcmp(function_table[i].id, id) == 0){
            return i;
        }
    }
    return -1;
}

void unknown_var(char *id){
    char msg [1024];
    snprintf(msg, 18+1+strlen(id), "unknown variable %s, ", id);
    yyerror(msg);
}


int str_search(char *id){
    int i;
    for (i = count_str-1; i>= 0; i--){
        if (strcmp(string_table[i].id, id) == 0){
            return i;
        }
    }
    return -1;
}

void insert_str(char *strA, char *strB, int index, char *strC){
    char A[strlen(strA)];
    strcpy(A, strA);

    strncpy(strC, A, index);
    strC[index] = '\0';
    strcat(strC, strB);
    strcat(strC, A + index);
}

void assigne_types(char *func, char *types){
    int index = func_search(func);
    if (index < 0){
        yyerror("function not declared");
    } else{
        struct arg_node *current = function_table[index].head;
        int index_types = 0;
        while(current){
            
            insert_str(types, current->data_type, index_types, types);
            current = current->next;
            index_types ++;
            while (types[index_types] != ',' && index_types < strlen(types)){
                index_types++;
            }
            index_types++;
            
        }
    }
}


void add_if_stack(int value){

    struct Stack *new_node = (struct Stack*)malloc(sizeof(struct Stack));
    new_node->value = value;
    new_node->next = IfHead;
    IfHead = new_node;

}
void pop_if_stack(){

    struct Stack *tmp = IfHead;
    IfHead = IfHead->next;
    free_head(tmp);

}

int get_top_if_stack(){
    return IfHead->value;
}

void add_for_stack(int value){

    struct Stack *new_node = (struct Stack*)malloc(sizeof(struct Stack));
    new_node->value = value;
    new_node->next = ForHead;
    ForHead = new_node;

}
void pop_for_stack(){
    struct Stack *tmp = ForHead;
    ForHead = ForHead->next;
    free_head(tmp);

}

int get_top_for_stack(){
    return ForHead->value;
}


void add_arg_stack(int value){

    struct Stack *new_node = (struct Stack*)malloc(sizeof(struct Stack));
    new_node->value = value;
    new_node->next = ArgHead;
    ArgHead = new_node;

}
int pop_arg_stack(){
    struct Stack *tmp = ArgHead;
    ArgHead = ArgHead->next;
    int value = tmp->value;
    free_head(tmp);
    return value;

}

int get_top_arg_stack(){
    return ArgHead->value;
}

void remove_after_dot(char *string){
    int index = 0;
    while (string[index] != '.' && strlen(string) > index){
        index ++;
    }
    string[index] = '\0';
}

void free_head(struct Stack* head){
    struct Stack* next = head->next;
    while (next){
        free(head);
        head = next;
        next = head->next;
    }
}
