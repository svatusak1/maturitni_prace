// TODO make possible seznam[i] = seznam[i+1]
// TODO make "string" also an expression so you can print it imediatly; call print("ahooj")
// TODO free all the heap allocated mem (don't forget strdup)

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

void remove_after_dot(char *string);
void insert_str(char *strA, char *strB, int index, char *strC);


int yylex(void);
extern int input_file_line_no;

int yyerror(const char *);
void unknown_var(char *);

extern FILE *yyin;
FILE *temp_out;
FILE *temp_hold;
FILE *out;


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
int search_str_table(char *);
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


char type[32];
void add_symb_table(char, char*);
struct symbolDataType {
    char *data_type;
    char *id;
    char *symbol_type;
    int line_number;
    int version;
} symbol_table[1024];
int count_symbol_table = 0;

void insert_type(char*);

int search_symb_table(char*);


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

int search_func_table(char *);
char *func_ret_type;
int in_function = 0;

char string_hold[1024] = "";

void assigne_types(char *func, char *types);


struct Stack{
    int value;
    struct Stack *next;
};

struct Stack *IfHead = NULL;


void add_if_stack(int value);
void pop_if_stack();
int get_top_if_stack();

struct Stack *ForHead = NULL;

void add_for_stack(int value);
void pop_for_stack();
int get_top_for_stack();

struct Stack *ArgHead = NULL;

void add_arg_stack(int value);
int pop_arg_stack();
int get_top_arg_stack();

struct ArrStack{
    char *value;
    struct ArrStack *next;
};

struct ArrStack *ArrHead = NULL;

void add_arr_stack(char *value);
char *pop_arr_stack();
char *get_top_arr_stack();
void free_arr_head(struct ArrStack *head);
void print_arr_stack();
char arr_type[32];
int arr_change_version;

void free_head(struct Stack*);

%}

%union{
    char *id;
    char arguments[1024];
    struct arg_node *input_node;
}

%token START_OF_FILE PLUS MINUS TIMES DIVIDE RCURL SEMICOL COMMA EQL NEQ LSS GTR LEQ GEQ CALL DEF RTRN LOOP TO IF LPAREN RPAREN LBRACK RBRACK LCURL ASSIGN CAPACITY LEN COMMENT MULTICOMMENT PRINT ARRTYPE
%token <id> IDENT NUMBER STR BYTE INT STRTYPE

%type st program statement declarations func_dec variable_dec change_val comment flow_control range block step condition function_line function_block arg_func_datatype return
%type <id> access_array expression datatype value func_datatype comp function_call step
%type <arguments> arg_val array_spec
%type <input_node> func_inp arg_func


%left IDENT
%right LBRACK
%left PLUS MINUS
%left TIMES DIVIDE
%right ASSIGN
%nonassoc EQL NEQ LSS GTR LEQ GEQ CALL

%start st


%%

st : START_OF_FILE
   {
   add_symb_table('K', "file_begin");
   fprintf(out, "source_filename = \"Module\" \ntarget triple = \"x86_64-w64-windows-gnu\"\n\n");
   fprintf(out, "@newline__ = private constant [2 x i8] c\"\\0A\\00\"\n");
   fprintf(out, "@num_str__ = private constant [4 x i8] c\"%%d\\0A\\00\"\n");
   }
   program
   ;

program : program statement
	| statement 
	;

statement : declarations
	| expression
	| flow_control 
    | change
	| comment 
	;

change : change_array
       | change_val
       ;


change_array : IDENT array_spec
             {
             int index = search_symb_table($1);
             if (index >= 0){
                  struct ArrStack *current = ArrHead;
                    int len = 0;
                    while(current->next){
                    len++;
                    current = current->next;
                    }
                    current = ArrHead;
                  int i = 0;
                  while (current && i < len){
                  struct ArrStack *tmp = current;
                    while(current->next){
                    current = current->next;
                    }
                    current->next = tmp;
                  struct ArrStack *tmp1 = tmp->next;
                    tmp->next = NULL;
                    current = tmp1;
                    i++;
                    }
                  char spec[32];
                    snprintf(spec, 6+strlen(current->value)+1, ", i32 %s", current->value);
                current = current->next;
                while (current){
                    char *tmp = strdup(spec);
                    snprintf(spec, strlen(tmp)+6+strlen(current->value)+1, "%s, i32 %s", tmp, current->value);
                    current = current->next;
                }
                
                 char *data_type = symbol_table[index].data_type;
                 fprintf(temp_out, "%%idx_%s_.%d = getelementptr %s, ptr %%%s0, i32 0%s\n", $1, symbol_table[index].version, data_type, $1, spec);
                 i = strlen(data_type);
                 while (i >= 0 && data_type[i] != ' '){
                    i--;
                };
                i++;
                int indentation = 0;
                while (i < strlen(data_type) && data_type[i] != ']'){
                    snprintf(arr_type+indentation, 1+1, "%c", data_type[i]);
                    indentation++;
                    i++;
                    }
             } else{
                unknown_var($1);
                }
            ArrHead = NULL;
            arr_change_version = symbol_table[index].version;
            symbol_table[index].version++;
             } ASSIGN expression
             {
             int index = search_symb_table($1);
             if (index >= 0){
                 fprintf(temp_out, "store %s %s, ptr %%idx_%s_.%d\n", arr_type, $5, $1, arr_change_version);
                }
             }
             ;

array_spec : LBRACK expression RBRACK { add_arr_stack($2); }
                  | array_spec LBRACK expression RBRACK { add_arr_stack($3); }
                  ;


declarations : func_dec 
	| variable_dec
    | string_dec
    | array_dec
	;


array_dec : ARRTYPE datatype IDENT array_spec
          {
// TODO declaration of list with initialization arr int seznam[100] = call bubble_sort(to_sort, 100)
          char spec[32];
          struct ArrStack *current = ArrHead;
          snprintf(spec, 1+strlen($2)+3+strlen(current->value)+1+1, "[%s x %s]", current->value, $2);
          current = current->next;
          while (current){
              char *tmp = strdup(spec);
              snprintf(spec, 1+strlen(current->value)+3+strlen(tmp)+1+1, "[%s x %s]", current->value, tmp);
              current = current->next;
          }
          fprintf(temp_out, "%%%s0 = alloca %s\n", $3, spec);
          insert_type(spec);
          add_symb_table('A', $3);
          ArrHead = NULL;
          }
          | ARRTYPE datatype IDENT array_spec ASSIGN expression
          {
          char spec[32];
          struct ArrStack *current = ArrHead;
          snprintf(spec, 1+strlen($2)+3+strlen(current->value)+1+1, "[%s x %s]", current->value, $2);
          current = current->next;
          while (current){
              char *tmp = strdup(spec);
              snprintf(spec, 1+strlen(current->value)+3+strlen(tmp)+1+1, "[%s x %s]", current->value, tmp);
              current = current->next;
          }
          fprintf(temp_out, "%%%s0 = alloca %s\n", $3, spec);
          fprintf(temp_out, "store %s %s, ptr %%%s0\n", spec, $6, $3);
          insert_type(spec);
          add_symb_table('A', $3);
          ArrHead = NULL;
          }

          ;

variable_dec : datatype IDENT ASSIGN expression {
             add_symb_table('V', $2);
            fprintf(temp_out, "%%%s0 = alloca %s\n", $2, $1);
            fprintf(temp_out, "store %s %s, ptr %%%s0\n", $1, $4, $2);
            }

;

datatype : BYTE { $$ = "i8"; insert_type("i8"); }
         | INT { $$ = "i32"; insert_type("i32"); }
    ;

string_dec : STRTYPE IDENT ASSIGN STR
           {
           int len = strlen($4)-2+1;

           // char *str_type = (char *)malloc(7+len+1);
           // snprintf(str_type, 7+len+1, "[%d x i8]", len);
           // insert_type(str_type);
           insert_type("str");
           add_symb_table('V', $2);
                // free(str_type);

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
           insert_type(symbol_table[search_symb_table($1)].data_type);
           } expression {
           fprintf(temp_out, "store %s %s, ptr %%%s0\n", type, $4, $1);
           }
           ;

func_dec : DEF
         {
         add_symb_table('K', "def");
         temp_hold = temp_out; temp_out = out; fprintf(temp_out, "\ndefine ");
         function_table[count_function_table].line_number = input_file_line_no;
         in_function = 1;
         }
         func_datatype
         {
         function_table[count_function_table].data_type = strdup($3);
         func_ret_type = function_table[count_function_table].data_type;
         fprintf(temp_out, "%s", $3);
         ArrHead = NULL;
         }
         IDENT LPAREN
         {
         function_table[count_function_table].id = $5;
         fprintf(temp_out, " @%s(", $5);
         add_symb_table('F', $5);
         }
         func_inp RPAREN
         {
         ArrHead = NULL;
         
         fprintf(temp_out, "){\nentry:\n");
         
         struct arg_node *node = function_table[count_function_table].head;
         while(node){
             fprintf(temp_out, "%%%s0 = alloca %s\n", node->id, node->data_type);
             fprintf(temp_out, "store %s %%%s, ptr %%%s0\n", node->data_type, node->id, node->id);
             node = node->next;
        }
            
         count_function_table++;
         }
         LCURL function_block RCURL
         {
         fprintf(temp_out, "}\n\n"); temp_out = temp_hold; in_function = 0;
         fprintf(out, string_hold);
         snprintf(string_hold, 1, "\0");
         }
         ;

func_inp : arg_func {$$ = $1; function_table[count_function_table].head = $1; }
	| func_inp { fprintf(temp_out, ", "); } COMMA arg_func
    {
    $1->next = $4;
    $$ = $4;
    }
	| { }
	;

arg_func : arg_func_datatype IDENT
         {
         fprintf(temp_out, " %%%s", $2);
         add_symb_table('I', $2);
         $$ = (struct arg_node*)malloc(sizeof(struct arg_node));
         $$->id = $2;
         $$->data_type = strdup(type);
         $$->next = NULL;
         }
         | arg_func_datatype IDENT array_spec 
         {
          char spec[32];
          struct ArrStack *current = ArrHead;
          snprintf(spec, 1+strlen($2)+3+strlen(current->value)+1+1, "[%s x %s]", current->value, type);
          current = current->next;
          while (current){
              char *tmp = strdup(spec);
              snprintf(spec, 1+strlen(current->value)+3+strlen(tmp)+1+1, "[%s x %s]", current->value, tmp);
              current = current->next;
          }
         fprintf(temp_out, "%s %%%s", spec, $2);
         insert_type(spec);
         add_symb_table('I', $2);
         $$ = (struct arg_node*)malloc(sizeof(struct arg_node));
         $$->id = $2;
         $$->data_type = strdup(type);
         $$->next = NULL;
         }
         ;

arg_func_datatype : BYTE { insert_type("i8"); fprintf(temp_out, "i8"); }
                  | INT { insert_type("i32"); fprintf(temp_out, "i32"); }
                  | ARRTYPE datatype
                  ;

func_datatype : BYTE { $$ = "i8"; insert_type($$); }
	| INT { $$ = "i32"; insert_type($$); }
    | ARRTYPE datatype array_spec 
    {
          char spec[32];
          struct ArrStack *current = ArrHead;
          snprintf(spec, 1+strlen($2)+3+strlen(current->value)+1+1, "[%s x %s]", current->value, type);
          current = current->next;
          while (current){
              char *tmp = strdup(spec);
              snprintf(spec, 1+strlen(current->value)+3+strlen(tmp)+1+1, "[%s x %s]", current->value, tmp);
              current = current->next;
          }
          insert_type(spec);
          $$ = spec;
    }
	;

function_block : function_line 
	| function_block function_line
	;

function_line : statement 
	| return
	;

return : RTRN expression
       {
       add_symb_table('K', "return"); 
       fprintf(temp_out, "ret %s %s\n", func_ret_type, $2);
       }
       ;


expression : expression PLUS expression
           {
           $$ = newTemp(); fprintf(temp_out, "%s = add %s %s, %s\n", $$, type, $1, $3);
           range.start_type = type;
           }
	       
		   | expression MINUS expression
	       {
	       $$ = newTemp(); fprintf(temp_out, "%s = sub %s %s, %s\n", $$, type, $1, $3); range.start_type = type;
	       }
	       
		   | expression TIMES expression
	       {
	       $$ = newTemp(); fprintf(temp_out, "%s = mul %s %s, %s\n", $$, type, $1, $3); range.start_type = type;
	       }
	       
		   | expression DIVIDE expression
	       {
	       $$ = newTemp(); fprintf(temp_out, "%s = udiv %s %s, %s\n", $$, type, $1, $3); range.start_type = type;
           }
	       
		   | LPAREN expression RPAREN { $$ = $2; }
           
		   | value { $$ = $1; range.start_type = type; }
           | function_call { $$ = newTemp(); fprintf(temp_out, "%s = %s\n", $$, $1); }
           | access_array
	       ;

value : IDENT
      {
      int index = search_symb_table($1);
      if ( index < 0){
        unknown_var($1);
      } else {
          char version[512];
          itoa(symbol_table[index].version, version, 10);
          $$ = (char*)malloc(sizeof(char) * (strlen(yylval.id)+ 1 + strlen(version) + 1));
          snprintf($$, 1+strlen(yylval.id)+1+strlen(version)+1, "%%%s.%s", yylval.id, version);
          int str_index = search_str_table($1);
          if (str_index < 0){
              fprintf(temp_out, "%s = load %s, ptr %%%s0\n", $$, symbol_table[index].data_type, $1, $1);
              symbol_table[index].version++;
              snprintf(type, strlen(symbol_table[index].data_type)+1, symbol_table[index].data_type);
          }
      }

      }
      | NUMBER { $$ = yylval.id; insert_type("i32"); }
      ;

access_array : IDENT array_spec
      {
         int index = search_symb_table($1);
         if (index >= 0){
              struct ArrStack *current = ArrHead;
                int len = 0;
                while(current->next){
                len++;
                current = current->next;
                }
                current = ArrHead;
              int i = 0;
              while (current && i < len){
              struct ArrStack *tmp = current;
                while(current->next){
                current = current->next;
                }
                current->next = tmp;
              struct ArrStack *tmp1 = tmp->next;
                tmp->next = NULL;
                current = tmp1;
                i++;
                }
              char spec[32];
                snprintf(spec, 6+strlen(current->value)+1, ", i32 %s", current->value);
            current = current->next;
            while (current){
                char *tmp = strdup(spec);
                snprintf(spec, strlen(tmp)+6+strlen(current->value)+1, "%s, i32 %s", tmp, current->value);
                current = current->next;
            }

char *data_type = symbol_table[index].data_type;
             fprintf(temp_out, "%%idx_%s_.%d = getelementptr %s, ptr %%%s0, i32 0%s\n", $1, symbol_table[index].version, data_type, $1, spec);
             i = strlen(data_type);
             while (i >= 0 && data_type[i] != ' '){
                i--;
            };
            i++;
            char arr_type[32];
            int indentation = 0;
            while (i < strlen(data_type) && data_type[i] != ']'){
                snprintf(arr_type+indentation, 1+1, "%c", data_type[i]);
                indentation++;
                i++;
                }

$$ = newTemp();
    fprintf(temp_out, "%s = load %s, ptr %%idx_%s_.%d\n", $$, arr_type, $1, symbol_table[index].version);
         } else{
            unknown_var($1);
            }
            ArrHead = NULL;
         symbol_table[index].version++;
         //TODO check if correct indexing
         }
 


function_call : CALL IDENT
              LPAREN
              arg_val RPAREN 
              {
              assigne_types($2, $4);
              add_symb_table('K', "call");
              int index = search_symb_table($2);
              char *func_ret_type_tmp;
              if (index >=0){
                  func_ret_type_tmp = symbol_table[index].data_type; 
                  insert_type(func_ret_type);
                  // TODO get rid of malloca and set the $$ type to char[]
                  $$ = (char*)malloc((5+strlen(func_ret_type_tmp)+2+strlen($2)+1+strlen($4)+1+1)*sizeof(char));
                  snprintf($$, 5+strlen(func_ret_type_tmp)+2+strlen($2)+1+strlen($4)+1+1, "call %s @%s(%s)", func_ret_type_tmp, $2, $4);
              } else {
                    yyerror("Function not declared");
                }
              pop_arg_stack();
            }

	| CALL LEN LPAREN IDENT RPAREN
    {
    add_symb_table('K', "len-func");
    int index = search_str_table($4);
    int symb_index = search_symb_table($4);
    if (index >= 0){
        char res[32];
        snprintf(res, 11+10+1, "add i32 0, %d", string_table[index].len-1);
        $$ = res;
    } else if (symb_index >= 0){
        
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

            if (search_str_table($4) >= 0){
                snprintf(res, 30+strlen($4)+45+1, "call i32 @__mingw_printf(ptr @%s)\ncall i32 @__mingw_printf(ptr @newline__)\n", $4);
            } else{
                int index = search_symb_table($4);
                if (index >= 0){
                    char *data_type = symbol_table[index].data_type;
                     $$ = newTemp();
                    fprintf(temp_out, "%s = load %s, ptr %%%s0\n", $$, data_type, $4);
                     if (strcmp(data_type, "i32") != 0){
                        char *tmp_var = newTemp();
                        fprintf(temp_out, "%s = sext %s %s to i32\n", tmp_var, data_type, $$);
                        $$ = tmp_var;
                    }
                     snprintf(res, 45+strlen($$)+2+1, "call i32 @__mingw_printf(ptr @num_str__, i32 %s)\n", $$);
                } else{
                    unknown_var($4);
                }
                temp_strCount++;
            }
            $4--;
        } else{
             snprintf(res, 45+strlen($4)+2+1, "call i32 @__mingw_printf(ptr @num_str__, i32 %s)\n", $4);
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
    }
	;

arg_val : expression
        {
            snprintf($$, 1 + strlen($1)+1, " %s", $1);
            add_arg_stack(strlen($1)+1);
        }
        | arg_val COMMA expression
        {
        int arg_len = pop_arg_stack();
        int len = 2+strlen($3)+1;
        snprintf($$+arg_len, len, ", %s", $3);
        add_arg_stack(arg_len+len-1);
        }
        | {}
        ;




flow_control : LOOP {
             loopCounter++;
             add_for_stack(loopCounter);
             fprintf(temp_out, "br label %%entry_loop%d\n\n", get_top_for_stack());
             fprintf(temp_out, "entry_loop%d:\n", get_top_for_stack());
             add_symb_table('K', "loop");
             }
             LPAREN datatype IDENT
             SEMICOL range RPAREN
{
    fprintf(temp_out, "%%%s0 = alloca %s\n", $5, type);
    add_symb_table('V', $5);
    fprintf(temp_out, "store %s %s, ptr %%%s0\n", type, range.start, $5);
    fprintf(temp_out, "%%loop_var_comp%d__ = load %s, ptr %%%s0\n", get_top_for_stack(), type, $5);
    fprintf(temp_out, "%%max%d = add i32 0, %s\n", get_top_for_stack(), range.end);
    fprintf(temp_out, "%%condition_for%d = icmp sgt %s %%max%d, %%loop_var_comp%d__\n", get_top_for_stack(), type, get_top_for_stack(), get_top_for_stack());
    fprintf(temp_out, "br label %%loop_start%d\n\n", get_top_for_stack());

    fprintf(temp_out, "loop_start%d:\n", get_top_for_stack());
    fprintf(temp_out, "%%i.check%d = load %s, ptr %%%s0\n", get_top_for_stack(), type, $5);
    fprintf(temp_out, "br i1 %%condition_for%d, label %%sgt1%d__, label %%slt1%d__\n\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());

    fprintf(temp_out, "sgt1%d__:\n", get_top_for_stack());
    fprintf(temp_out, "%%done_sgt%d = icmp sgt i32 %%i.check%d, %%max%d\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());
    fprintf(temp_out, "br i1 %%done_sgt%d, label %%continue_loop%d, label %%loop%d\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());

    fprintf(temp_out, "slt1%d__:\n", get_top_for_stack());
    fprintf(temp_out, "%%done_slt%d = icmp slt i32 %%i.check%d, %%max%d\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());
    fprintf(temp_out, "br i1 %%done_slt%d, label %%continue_loop%d, label %%loop%d\n\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());

    fprintf(temp_out, "loop%d:\n", get_top_for_stack());
}
             block
             {
             fprintf(temp_out, "\n%%loop_var%d__ = load i32, ptr %%%s0\n", get_top_for_stack(), $5);
             fprintf(temp_out, "br i1 %%condition_for%d, label %%sgt2%d__, label %%slt2%d__\n\n", get_top_for_stack(), get_top_for_stack(), get_top_for_stack());
             
             fprintf(temp_out, "sgt2%d__:\n", get_top_for_stack());
             fprintf(temp_out, "%%new_loop_var_sgt%d__ = add i32 %s, %%loop_var%d__\n", get_top_for_stack(), range.step, get_top_for_stack());
             fprintf(temp_out, "store i32 %%new_loop_var_sgt%d__, ptr %%%s0\n", get_top_for_stack(), $5);
             fprintf(temp_out, "br label %%loop_start%d\n", get_top_for_stack());

             fprintf(temp_out, "slt2%d__:\n", get_top_for_stack());
             fprintf(temp_out, "%%new_loop_var_slt%d__ = add i32 -%s, %%loop_var%d__\n", get_top_for_stack(), range.step, get_top_for_stack());
             fprintf(temp_out, "store i32 %%new_loop_var_slt%d__, ptr %%%s0\n", get_top_for_stack(), $5);
             fprintf(temp_out, "br label %%loop_start%d\n\n", get_top_for_stack());

             fprintf(temp_out, "continue_loop%d:\n\n", get_top_for_stack());
             pop_for_stack();
             }
	| IF LPAREN
    {
    ifCounter ++;
    add_symb_table('K', "if");
    add_if_stack(ifCounter);
    }
    condition RPAREN
    {
    fprintf(temp_out, "br i1 %%condition_if%d, label %%if%d, label %%continue_if%d\nif%d:\n", get_top_if_stack(), get_top_if_stack(), get_top_if_stack(), get_top_if_stack());
    }
    block
    { fprintf(temp_out, "br label %%continue_if%d\ncontinue_if%d:\n\n", get_top_if_stack(), get_top_if_stack()); 
    pop_if_stack();
    }
    ;

range : expression TO expression { range.start = $1; range.end = $3; range.end_type = type; range.step = "1"; }
      | expression TO expression SEMICOL step { range.start = $1; range.end = $3; range.step = $5; }
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
          fprintf(temp_out, "%%condition_if%d = icmp %s i32 %s, %s\n", get_top_if_stack(), $2, $1, $3);
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
    fp = fopen("bubble_sort.rog","r");
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



void insert_type(char *type_to_insert){
    int ret = snprintf(type, 32, "%s", type_to_insert);
    if (ret < strlen(type)){
        yyerror("error inserting type");
    }
}


void add_symb_table(char c, char *id){
    
    int found;
    if (c == 'K'){
        found = -1;
    } else {
        found = search_symb_table(id);
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
        A array
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
            case 'A':
                symbol_table[count_symbol_table].data_type = strdup(type);
                symbol_table[count_symbol_table].symbol_type = "Array";
                break;

            default:
                yyerror("symbol not found");
        }
        count_symbol_table++;
    } else {
        char name[9];
        switch (c){
            case 'V':
                snprintf(name, 8+1, "variable");
                break;
            case 'F':
                snprintf(name, 8+1, "function");
            case 'A':
                snprintf(name, 5+1, "array");
        }
        char final[8+45+1];
        snprintf(final, 8+45+1, "Multiple %s declarations aren't allowed", name);
        yyerror(final);
    }
}

int search_symb_table(char *id){
    int i;
    for (i = count_symbol_table-1; i>= 0; i--){
        if (strcmp(symbol_table[i].id, id) == 0){
            return i;
        }
    }
    return -1;
}


int search_func_table(char *id){
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


int search_str_table(char *id){
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
    int index = search_func_table(func);
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


void add_arr_stack(char *value){

    struct ArrStack *new_node = (struct ArrStack*)malloc(sizeof(struct ArrStack));
    new_node->value = value;
    new_node->next = ArrHead;
    ArrHead = new_node;

}
char *pop_arr_stack(){
    struct ArrStack *tmp = ArrHead;
    ArrHead = ArrHead->next;
    char *value = tmp->value;
    free_arr_head(tmp);
    return value;

}

char *get_top_arr_stack(){
    return ArrHead->value;
}

void remove_after_dot(char *string){
    int index = 0;
    while (string[index] != '.' && strlen(string) > index){
        index ++;
    }
    string[index] = '\0';
}

void free_head(struct Stack *head){
    struct Stack *next = head->next;
    while (next){
        free(head);
        head = next;
        next = head->next;
    }
}

void free_arr_head(struct ArrStack *head){
    struct ArrStack *next = head->next;
    while (next){
        free(head);
        head = next;
        next = head->next;
    }
}


void print_arr_stack(){
    struct ArrStack *current = ArrHead;
    while (current){
        printf("%s\n", current->value);
        current = current->next;
        }
        }
