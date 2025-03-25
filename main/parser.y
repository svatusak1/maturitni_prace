%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

void remove_after_dot(char *string);
void insert_str(char *original_string, char *str_to_insert, int index, char *result_string);
int digit_length(int number);

int yylex(void);
extern int input_file_line_no;

void print_tables();

int yyerror(const char *);
void unknown_var(char *);

extern FILE *yyin;
FILE *temp_out;
FILE *temp_hold;
FILE *out;


char current_var_type = 'E';

int tempCounter = 0;
char *new_temp_var() {
    char *temp = (char*)malloc(16*sizeof(char));
    sprintf(temp, "%%t%d", tempCounter++);
    return temp;
}
int is_temp_var(char *variable);

// Symbol table
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

// Strings
int temp_strCount = 0;
int get_str_len(char *name);
int string_exists(char *name);



// function structures
struct functionDataType {
    char *data_type;
    char *id;
    int line_number;
    struct arg_node *head;

} function_table[64];
int count_function_table = 0;

struct arg_node {
    char *id;
    char *data_type;
    struct arg_node *next;
};

int search_func_table(char *);
int in_function = 0;

char string_hold[1024] = "";

void assigne_types(char *func, char *types);


struct Stack{
    int value;
    struct Stack *next;
};

// if structures
int ifCounter = 0;

struct Stack *IfHead = NULL;
void add_if_stack(int value);
void pop_if_stack();


// loop structures
int loopCounter = 0;

struct loop_range {
    char *start;
    char *start_type;
    char *end;
    char *end_type;
    char *step;
};

struct loop_range range = {"0", "0", "1"};

struct Stack *LoopHead = NULL;
void add_for_stack(int value);
void pop_for_stack();

// array structures
struct ArrStack{
    char *value;
    struct ArrStack *next;
};

struct ArrStack *ArrHead = NULL;
void add_arr_stack(char *value);
char *pop_arr_stack();

void reverse_order_array_stack(struct ArrStack *head);
int length_array_stack(struct ArrStack *head);
char *get_basic_array_type(char * data_type);
char *make_array_indexes(struct ArrStack* head);
char *make_array_type(struct ArrStack *head, char *initial_type);

int arr_change_version;
int array_exists(char *name);


%}

%union{
    char *id;
    char arguments[1024];
    struct arg_node *input_node;
}

%token START_OF_FILE PLUS MINUS TIMES DIVIDE RCURL SEMICOL COMMA EQL NEQ LSS GTR LEQ GEQ CALL DEF RTRN LOOP TO IF LPAREN RPAREN LBRACK RBRACK LCURL ASSIGN CAPACITY LEN COMMENT MULTICOMMENT PRINT ARRTYPE VOID
%token <id> IDENT NUMBER STR BYTE INT STRTYPE

%type st program statement declarations function_dec variable_dec change_val comment flow_control range block step condition function_line function_block return
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
        | expression { free($1); }
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
                      reverse_order_array_stack(ArrHead);

                      char *spec = make_array_indexes(ArrHead);

                      fprintf(temp_out, "%%idx_%s_.%d = getelementptr %s, ptr %%%s0, i32 0%s\n", $1, symbol_table[index].version, symbol_table[index].data_type, $1, spec);
                      free(spec);

                 } else{
                        unknown_var($1);
                 }
                 ArrHead = NULL;
                 // remember version as assigned expression could be the same array
                 arr_change_version = symbol_table[index].version;
                 symbol_table[index].version++;
             } ASSIGN expression
             {
                 int index = search_symb_table($1);
                 if (index >= 0){
                    char *arr_type = get_basic_array_type(symbol_table[index].data_type);
                    fprintf(temp_out, "store %s %s, ptr %%idx_%s_.%d\n", arr_type, $5, $1, arr_change_version);
                    free(arr_type);
                 }
             }
             ;

array_spec : LBRACK expression RBRACK { add_arr_stack($2); }
                  | array_spec LBRACK expression RBRACK { add_arr_stack($3); }
                  ;


declarations : function_dec 
             | variable_dec
             | string_dec
             | array_dec
             ;


array_dec : ARRTYPE datatype IDENT array_spec
          {
          char *spec = make_array_type(ArrHead, $2);
          fprintf(temp_out, "%%%s0 = alloca %s\n", $3, spec);
          insert_type(spec);
          add_symb_table('A', $3);
          ArrHead = NULL;
          }

          | ARRTYPE datatype IDENT array_spec ASSIGN expression
          {
          char *exp_ident = strdup($6);
          exp_ident++;
          remove_after_dot(exp_ident);
          int index = search_symb_table(exp_ident);
          if (index >= 0){
              if (strcmp(symbol_table[index].symbol_type, "Array") == 0 ){
                  char *spec = make_array_type(ArrHead, $2);
                  if (strcmp(spec, symbol_table[index].data_type) == 0){
                      fprintf(temp_out, "%%%s0 = alloca %s\n", $3, spec);
                      fprintf(temp_out, "store %s %s, ptr %%%s0\n", spec, $6, $3);
                      insert_type(spec);
                      add_symb_table('A', $3);
                  } else {
                      yyerror("array types do not match");
                  }
                  free(spec);
              } else {
                  yyerror("Invalid type for arrray initialization");
              }
          } else {
              unknown_var($6);
          }
          ArrHead = NULL;
          }
          ;

variable_dec : datatype IDENT ASSIGN expression {
             add_symb_table('V', $2);
             fprintf(temp_out, "%%%s0 = alloca %s\n", $2, $1);
             fprintf(temp_out, "store %s %s, ptr %%%s0\n", $1, $4, $2);
             }
             ;

datatype : BYTE { $$ = "i8"; insert_type($$); }
         | INT { $$ = "i32"; insert_type($$); }
         ;

string_dec : STRTYPE IDENT ASSIGN STR
           {

           $4[strlen($4)-1] = '\0';
           int length_of_str = strlen($4);

           int digit_len_of_length_str = digit_length(length_of_str);

           char *str_type = (char*)malloc(1+digit_len_of_length_str+6+1);
           sprintf(str_type, "[%d x i8]", length_of_str);
           insert_type(str_type);
           add_symb_table('S', $2);
           free(str_type);

           char *res = (char *)malloc(sizeof(char) * (1+strlen($2)+21+digit_len_of_length_str+8+length_of_str+4+1));
           sprintf(res, "@%s = private constant [%d x i8] c%s\\00\"\n", $2, length_of_str, $4);

           if (in_function){
            strcat(string_hold, res);
           } else{
            fprintf(out, "%s", res);
           }

           free(res);
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

function_dec : DEF
         {
         add_symb_table('K', "def");
         temp_hold = temp_out; temp_out = out; fprintf(temp_out, "\ndefine ");
         function_table[count_function_table].line_number = input_file_line_no;
         in_function = 1;
         }
         func_datatype
         {
         function_table[count_function_table].data_type = strdup($3);
         fprintf(temp_out, "%s", $3);
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
         
         // make pointers from argument so one can work with them
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
         if (strcmp($3, "void") == 0){
            fprintf(temp_out, "ret void\n");
         }
         fprintf(temp_out, "}\n\n"); temp_out = temp_hold; in_function = 0;
         fprintf(out, "%s", string_hold);
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

arg_func : datatype IDENT
         {
         fprintf(temp_out, "%s %%%s", $1, $2);
         add_symb_table('I', $2);
         $$ = (struct arg_node*)malloc(sizeof(struct arg_node));
         $$->id = $2;
         $$->data_type = strdup(type);
         $$->next = NULL;
         }
         | ARRTYPE datatype IDENT array_spec 
         {
         char *spec = make_array_type(ArrHead, $2);
         fprintf(temp_out, "%s %%%s", spec, $3);
         insert_type(spec);
         free(spec);
         add_symb_table('I', $3);
         $$ = (struct arg_node*)malloc(sizeof(struct arg_node));
         $$->id = $3;
         $$->data_type = strdup(type);
         $$->next = NULL;
         }
         ;


func_datatype : datatype
              | VOID { $$ = "void"; }
              | ARRTYPE datatype array_spec
              {
              char *spec = make_array_type(ArrHead, $2);
              insert_type(spec);
              $$ = spec;
              ArrHead = NULL;
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
       fprintf(temp_out, "ret %s %s\n", type, $2);
       }
       ;


expression : expression PLUS expression
           {
           $$ = new_temp_var(); fprintf(temp_out, "%s = add %s %s, %s\n", $$, type, $1, $3);
           free($1); free($3);
           current_var_type = 'T';
           }
               
                   | expression MINUS expression
               {
               $$ = new_temp_var(); fprintf(temp_out, "%s = sub %s %s, %s\n", $$, type, $1, $3);
           free($1); free($3);
           current_var_type = 'T';
               }
               
                   | expression TIMES expression
               {
               $$ = new_temp_var(); fprintf(temp_out, "%s = mul %s %s, %s\n", $$, type, $1, $3);
           free($1); free($3);
           current_var_type = 'T';
               }
               
                   | expression DIVIDE expression
               {
               $$ = new_temp_var(); fprintf(temp_out, "%s = udiv %s %s, %s\n", $$, type, $1, $3);
           free($1); free($3);
           current_var_type = 'T';
           }
               
                   | LPAREN expression RPAREN { $$ = $2; }
           
                   | value
           | function_call
           {
           $$ = new_temp_var(); fprintf(temp_out, "%s = %s\n", $$, $1);
           free($1);
           current_var_type = 'T';
           }
           | access_array { $$ = $1; current_var_type = 'T'; }
               ;

value : IDENT
      {
      int index = search_symb_table($1);
      if (index >= 0){
          insert_type(symbol_table[index].data_type);
          int version = symbol_table[index].version;
          $$ = (char*)malloc(1+strlen($1)+ 1 + digit_length(version) + 1);
          sprintf(type, "%s", symbol_table[index].data_type);
          if (string_exists($1) != 0){
              sprintf($$, "%s", $1);
              current_var_type = 'S';
          } else {
              sprintf($$, "%%%s.%d", $1, version);
              fprintf(temp_out, "%s = load %s, ptr %%%s0\n", $$, type, $1);
              symbol_table[index].version++;
              if (array_exists($1) != 0){
                  current_var_type = 'A';
              } else{
                  current_var_type = 'V';
              }

          }
      } else{
        unknown_var($1);
      }
      }
      | NUMBER { $$ = $1; 
      if (strcmp(type, "i32") != 0 && strcmp(type, "i8") != 0){
        insert_type("i32");
      }
      current_var_type = 'N';
      }
      ;

access_array : IDENT array_spec
      {
         $$ = new_temp_var();
         int index = search_symb_table($1);
         if (index >= 0){
            reverse_order_array_stack(ArrHead);

            char *spec = make_array_indexes(ArrHead);

            fprintf(temp_out, "%%idx_%s_.%d = getelementptr %s, ptr %%%s0, i32 0%s\n", $1, symbol_table[index].version, symbol_table[index].data_type, $1, spec);
            free(spec);

            char *arr_type = get_basic_array_type(symbol_table[index].data_type);
            fprintf(temp_out, "%s = load %s, ptr %%idx_%s_.%d\n", $$, arr_type, $1, symbol_table[index].version);
            free(arr_type);

         } else{
            unknown_var($1);
         }
         symbol_table[index].version++;
         ArrHead = NULL;
         }
 


function_call : CALL IDENT
              LPAREN
              arg_val RPAREN 
              {
              add_symb_table('K', "call");
              assigne_types($2, $4);

              int index = search_symb_table($2);
              if (index >=0){
                  char *func_ret_type = symbol_table[index].data_type;
                  insert_type(func_ret_type);
                  $$ = (char*)malloc((5+strlen(func_ret_type)+2+strlen($2)+1+strlen($4)+1+1)*sizeof(char));
                  sprintf($$, "call %s @%s(%s)", func_ret_type, $2, $4);
              } else {
                    yyerror("Function not declared");
                }
            }

        | CALL LEN LPAREN IDENT RPAREN
    {
    add_symb_table('K', "len-func");
    int index = search_symb_table($4);
    char *res;
    if (index >= 0){
        res = (char*)malloc(11+10+1);
        sprintf(res, "add i32 0, %d", get_str_len($4));
        $$ = res;
    } else{
        unknown_var($4);
    }
    }
    | CALL PRINT LPAREN RPAREN
    {
    char *res = (char*)malloc(41+1);
    sprintf(res, "call i32 @__mingw_printf(ptr @newline__)\n");
    $$ = res;
    }
    | CALL PRINT LPAREN STR RPAREN
    {
    // remove quotes
    $4++;
    $4[strlen($4)-1] = '\0';

    char *res = (char*)malloc(1+20+21+20+2+9+strlen($4)+2);
    sprintf(res, "@%d = private constant [%d x i8] c\"%s\\0A\\00\"\n", temp_strCount, (int)strlen($4)+2, $4);

    if (in_function){
        strcat(string_hold, res);
    } else{
        fprintf(out, "%s", res);
    }
    free(res);

    res = (char*)malloc(32+10+1);
    sprintf(res, "call i32 @__mingw_printf(ptr @%d)\n", temp_strCount);
    temp_strCount++;

    $$ = res;
    }
    | CALL PRINT LPAREN expression RPAREN 
    {
    char *res;
    int index;
    switch (current_var_type){
    // E-empty
    // A-array
    // T-temp_var
    // N-number V-variable(i8/i32)
        case 'A':
            $4++;
            remove_after_dot($4);
            index = search_symb_table($4);
            char *arr_datatype = symbol_table[index].data_type;
            int array_len = 7+(int)strlen($4)+13+(int)strlen(arr_datatype)+2;
            res = (char *)malloc(1+digit_length(temp_strCount)+21+digit_length(array_len)+18+(int)strlen($4)+15+(int)strlen(arr_datatype)+7+1);
            sprintf(res, "@%d = private constant [%d x i8] c\"array \\22%s\\22 with type: %s\\0A\\00\"\n", temp_strCount, array_len, $4, arr_datatype);
            if (in_function){
                strcat(string_hold, res);
            } else{
                fprintf(out, "%s", res);
            }
            res = (char *)malloc(30+10+2+1);
            sprintf(res, "call i32 @__mingw_printf(ptr @%d)\n", temp_strCount);
            temp_strCount++;
            break;
        case 'T':
            if (strcmp(type, "i8") == 0){
                char *tmp_var = new_temp_var();
                fprintf(temp_out, "%s = sext %s %s to i32\n", tmp_var, type, $4);
                $4 = tmp_var;
            }
            res = (char *)malloc(45+strlen($4)+2+1);
            sprintf(res, "call i32 @__mingw_printf(ptr @num_str__, i32 %s)\n", $4);
            break;
        case 'N':
            res = (char *)malloc(1+20+21+20+2+9+strlen($4)+2);
            sprintf(res, "@%d = private constant [%d x i8] c\"%s\\0A\\00\"\n", temp_strCount, (int)strlen($4)+2, $4);
            if (in_function){
                strcat(string_hold, res);
            } else{
                fprintf(out, "%s", res);
            }
            res = (char *)malloc(30+10+2+1);
            sprintf(res, "call i32 @__mingw_printf(ptr @%d)\n", temp_strCount);
            temp_strCount++;
            break;
        case 'V':
            $4++;
            remove_after_dot($4);
            index = search_symb_table($4);
            char *data_type = symbol_table[index].data_type;
            if (strcmp(data_type, "i8") == 0){
                char *tmp_var = new_temp_var();
                fprintf(temp_out, "%s = sext %s %%%s.%d to i32\n", tmp_var, data_type, $4, symbol_table[index].version-1);

                res = (char *)malloc(45+strlen($4)+2+1);
                sprintf(res, "call i32 @__mingw_printf(ptr @num_str__, i32 %s)\n", tmp_var);
                free(tmp_var);
            } else {
                int digit_len_version = digit_length(symbol_table[index].version-1);
                res = (char *)malloc(46+strlen($4)+1+digit_len_version+2+1);
                sprintf(res, "call i32 @__mingw_printf(ptr @num_str__, i32 %%%s.%d)\n", $4, symbol_table[index].version-1);
            }
            break;
        case 'S':
            res = (char *)malloc(30+strlen($4)+43+1);
            sprintf(res, "call i32 @__mingw_printf(ptr @%s)\ncall i32 @__mingw_printf(ptr @newline__)\n", $4);
            break;
        default:
            yyerror("variable type unsupported for print");
            break;
    }
    $$ = res;



    }
        ;

arg_val : expression
        {
            sprintf($$, " %s", $1);
        }
        | arg_val COMMA expression
        {
        char *tmp =(char*)malloc(sizeof(char)*(2+strlen($3)+1));
        sprintf(tmp, ", %s", $3);
        strcat($$, tmp);
        free(tmp);
        }
        | { sprintf($$, ""); }
        ;




flow_control : LOOP {
             loopCounter++;
             add_for_stack(loopCounter);
             fprintf(temp_out, "br label %%entry_loop%d\n\n", LoopHead->value);
             fprintf(temp_out, "entry_loop%d:\n", LoopHead->value);
             add_symb_table('K', "loop");
             }
             LPAREN datatype IDENT
             SEMICOL range RPAREN
             {
             fprintf(temp_out, "%%%s0 = alloca %s\n", $5, type);
             add_symb_table('V', $5);
             int stack_top = LoopHead->value;

             fprintf(temp_out, "store %s %s, ptr %%%s0\n", type, range.start, $5);
             fprintf(temp_out, "%%loop_var_comp%d__ = load %s, ptr %%%s0\n", stack_top, type, $5);
             fprintf(temp_out, "%%max%d = add i32 0, %s\n", stack_top, range.end);
             fprintf(temp_out, "%%condition_for%d = icmp sgt %s %%max%d, %%loop_var_comp%d__\n", stack_top, type, stack_top, stack_top);
             fprintf(temp_out, "br label %%loop_start%d\n\n", stack_top);

             fprintf(temp_out, "loop_start%d:\n", stack_top);
             fprintf(temp_out, "%%i.check%d = load %s, ptr %%%s0\n", stack_top, type, $5);
             fprintf(temp_out, "br i1 %%condition_for%d, label %%sgt1%d__, label %%slt1%d__\n\n", stack_top, stack_top, stack_top);

             fprintf(temp_out, "sgt1%d__:\n", stack_top);
             fprintf(temp_out, "%%done_sgt%d = icmp sgt i32 %%i.check%d, %%max%d\n", stack_top, stack_top, stack_top);
             fprintf(temp_out, "br i1 %%done_sgt%d, label %%continue_loop%d, label %%loop%d\n", stack_top, stack_top, stack_top);

             fprintf(temp_out, "slt1%d__:\n", stack_top);

             fprintf(temp_out, "%%done_slt%d = icmp slt i32 %%i.check%d, %%max%d\n", stack_top, stack_top, stack_top);
             fprintf(temp_out, "br i1 %%done_slt%d, label %%continue_loop%d, label %%loop%d\n\n", stack_top, stack_top, stack_top);
             fprintf(temp_out, "loop%d:\n", stack_top);
             }

             block
             {
             int stack_top = LoopHead->value;
             fprintf(temp_out, "\n%%loop_var%d__ = load i32, ptr %%%s0\n", stack_top, $5);
             fprintf(temp_out, "br i1 %%condition_for%d, label %%sgt2%d__, label %%slt2%d__\n\n", stack_top, stack_top, stack_top);
             
             fprintf(temp_out, "sgt2%d__:\n", stack_top);
             fprintf(temp_out, "%%new_loop_var_sgt%d__ = add i32 %%loop_var%d__, %s\n", stack_top, stack_top, range.step);
             fprintf(temp_out, "store i32 %%new_loop_var_sgt%d__, ptr %%%s0\n", stack_top, $5);
             fprintf(temp_out, "br label %%loop_start%d\n", stack_top);

             fprintf(temp_out, "slt2%d__:\n", stack_top);
             fprintf(temp_out, "%%new_loop_var_slt%d__ = sub i32 %%loop_var%d__, %s\n", stack_top, stack_top, range.step);
             fprintf(temp_out, "store i32 %%new_loop_var_slt%d__, ptr %%%s0\n", stack_top, $5);
             fprintf(temp_out, "br label %%loop_start%d\n\n", stack_top);

             fprintf(temp_out, "continue_loop%d:\n\n", stack_top);
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
             int stack_top = IfHead->value;
             fprintf(temp_out, "br i1 %%condition_if%d, label %%if%d, label %%continue_if%d\nif%d:\n", stack_top, stack_top, stack_top, stack_top);
             }
             block
             { fprintf(temp_out, "br label %%continue_if%d\ncontinue_if%d:\n\n", IfHead->value, IfHead->value); 
             pop_if_stack();
             }
             ;

range : expression { range.start_type = type; } TO expression step { range.start = $1; range.end = $4; range.step = $5; }
      ;

step : SEMICOL expression
     {
     if ($2[0] == '-'){
         $2++;
     }
     $$ = $2;
     }
     | { $$ = "1"; }
     ;

condition : expression comp expression
          {
          fprintf(temp_out, "%%condition_if%d = icmp %s i32 %s, %s\n", IfHead->value, $2, $1, $3);
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


int main(void) {
    FILE *rog_code;
    rog_code = fopen("bubble_sort.py", "r");
    yyin = rog_code;
    out = fopen("out.ll", "w");
    temp_out = fopen("temp_llvm.ll", "w");
    yyparse();

    fprintf(out, "\ndefine i32 @main() {\nentry:\n");

    fclose(rog_code);
    fclose(temp_out);

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
    remove("temp_llvm.ll");

    print_tables();

    return 0;
}


int yyerror(const char *s)
{
    fprintf(stderr,"%s on line: %d\n",s, input_file_line_no);
    return -1;
}

int yywrap(){
    return 1;
}

void insert_type(char *type_to_insert){
    int ret = sprintf(type, "%s", type_to_insert);
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
        symbol_table[count_symbol_table].data_type = strdup(type);
        switch (c){
        // K-keyword
        // C-consctant
        // V-variable
        // F-function dec
        // I-function input variable
        // A-array
        // S-strings
            case 'K':
                symbol_table[count_symbol_table].data_type = "N/A";
                symbol_table[count_symbol_table].symbol_type = "Keyword";
                break;

            case 'C':
                symbol_table[count_symbol_table].data_type = "CONSTAT";
                symbol_table[count_symbol_table].symbol_type = "Constant";
                break;

            case 'V':
                symbol_table[count_symbol_table].symbol_type = "Variable";
                break;

            case 'S':
                symbol_table[count_symbol_table].symbol_type = "String";
                break;

            case 'I':
                symbol_table[count_symbol_table].symbol_type = "Function_input";
                break;

            case 'F':
                symbol_table[count_symbol_table].symbol_type = "Funtion dec";
                break;
            case 'A':
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
                sprintf(name, "variable");
                break;
            case 'F':
                sprintf(name, "function");
            case 'A':
                sprintf(name, "array");
        }
        char final[8+45+1];
        sprintf(final, "Multiple %s declarations aren't allowed", name);
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
    sprintf(msg, "unknown variable %s, ", id);
    yyerror(msg);
}



void insert_str(char *original_string, char *str_to_insert, int index, char *result_string){
    // https://stackoverflow.com/a/2016015
    char A[strlen(original_string)];
    strcpy(A, original_string);
    strncpy(result_string, A, index);
    result_string[index] = '\0';
    strcat(result_string, str_to_insert);
    strcat(result_string, A + index);
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
    free(tmp);
}

void add_for_stack(int value){

    struct Stack *new_node = (struct Stack*)malloc(sizeof(struct Stack));
    new_node->value = value;
    new_node->next = LoopHead;
    LoopHead = new_node;

}
void pop_for_stack(){
    struct Stack *tmp = LoopHead;
    LoopHead = LoopHead->next;
    free(tmp);

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
    free(tmp);
    return value;

}


void remove_after_dot(char *string){
    int index = 0;
    while (string[index] != '.' && strlen(string) > index){
        index ++;
    }
    string[index] = '\0';
}

void reverse_order_array_stack(struct ArrStack *head){
    int len = length_array_stack(head);
    struct ArrStack *current = head;
    int i = 0;
    // reverse stack order
    while (current && i < len){
        struct ArrStack *tmp = current;
        //reach end of stack
        while(current->next){
            current = current->next;
        }
        // move first element to last position
        current->next = tmp;
        current = tmp->next;
        tmp->next = NULL;
        i++;
    }
}

int length_array_stack(struct ArrStack *head){
    struct ArrStack *current = head;
    int len = 1;
    while(current->next){
        len++;
        current = current->next;
    }
    return len;
}


char *get_basic_array_type(char *data_type){
      int i = strlen(data_type);
      while (i > 0 && data_type[i-1] != ' '){
        i--;
      };
      int indentation = 0;
      char *arr_type = (char*)malloc(5);
      while (i < strlen(data_type) && data_type[i] != ']'){
        sprintf(arr_type+indentation, "%c", data_type[i]);
        indentation++;
        i++;
      }
      return arr_type;
}

char *make_array_indexes(struct ArrStack* head){
    struct ArrStack* current = head;
    int len = length_array_stack(head);
    char *spec = (char*)malloc((6+3)*len+1);
    sprintf(spec, "");
    while (current){
        char *tmp = strdup(spec);
        sprintf(spec, "%s, i32 %s", tmp, current->value);
        free(tmp);
        current = current->next;
    }
    return spec;
}

char *make_array_type(struct ArrStack *head, char *initial_type){
    struct ArrStack *current = head;
    char *spec = (char*)malloc(1+strlen(initial_type)+3+strlen(current->value)+1+1);
    sprintf(spec, "[%s x %s]", current->value, initial_type);
    current = current->next;
    while (current){
        char *tmp = strdup(spec);
        sprintf(spec, "[%s x %s]", current->value, tmp);
        current = current->next;
        free(tmp);
    }
    return spec;
}

void print_tables(){
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
        struct arg_node *tmp = node;
        if (node){
            printf("%s %s", node->data_type, node->id);
            node = node->next;
            free(tmp->data_type);
            free(tmp);
        }
        while(node){
            printf(", %s %s", node->data_type, node->id);
            struct arg_node *tmp = node;
            node = node->next;
            free(tmp->data_type);
            free(tmp);
        }
        printf(")");
        printf("\t%d\n", function_table[i].line_number);
    }
    printf("\n\n");

}

int is_temp_var(char *variable){
    if (variable[0] != 't'){ return 0; }
    variable++;
    int i = 0;
    while (i < strlen(variable) && isdigit(variable[i]) != 0){
        i++;
        
    }
    if (i == strlen(variable)){
        return 1;
    } else {
        return 0;
    }
}

int get_str_len(char *name){
    int index = search_symb_table(name);
    if (index >= 0){
        char *type = symbol_table[index].data_type;
        type++;
        int i = 0;
        while (isdigit(type[i]) != 0){
            i++;
        }
        type[i] = '\0';
        int len = atoi(type);
        return len-1;
    } else{
        return -1;
    }
}

int array_exists(char *name){
    int i = count_symbol_table-1;
    while (i >= 0){
        if (strcmp(symbol_table[i].symbol_type, "Array") == 0 && strcmp(name, symbol_table[i].id) == 0){
            return 1;
        }
        i--;
    }
    return 0;
}

int string_exists(char *name){
    int i = count_symbol_table-1;
    while (i >= 0){
        if (strcmp(symbol_table[i].symbol_type, "String") == 0 && strcmp(name, symbol_table[i].id) == 0){
            return 1;
        }
        i--;
    }
    return 0;
}

int digit_length(int number){
    // https://stackoverflow.com/a/11151570
    int length = 1;
    while ( number /= 10 ){
       length++;
    }
    return length;
}
