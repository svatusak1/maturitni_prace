%{
#include <stdio.h>
#include <string.h>


int yylex(void);
int yyerror(const char *);

extern FILE *yyin;
FILE *out;

char type[10];
void add(char, char*);
struct symbolDataType {
    char *data_type;
    char *id_name;
    char *symbol_type;
    int line_number;
} symbol_table[50];
int count_symbol_table = 0;

struct function_name_type{
    char *name;
    char arg_type[10];
};

char func_type[10];
void add_func(char*);
struct functionDataType {
    char data_type[10];
    struct function_name_type *input_datatypes[20];
    int count_inp_datatypes;
    char *id_name;
} function_table[50];
int array_input_type_index = 0;
int count_function_table = 0;


extern int input_file_line_no;

void insert_type(char*);
void insert_func_type(char*);

struct node *mknode(struct node *left, struct node *right, char *token);

struct node{
    struct node *left;
    struct node *right;
    char *token;
};

struct node *head;
void printtree(struct node*);
void printInorder(struct node *);

%}

%union{
    struct node *obj_node;
    char end_node[100];
}

%token <end_node> START_OF_FILE DEF RTRN PLUS MINUS TIMES DIVIDE NUMBER STR CALL CAPACITY IDENT LEN LOOP IF EQL NEQ LSS GTR LEQ GEQ TO 
%token  RCURL SEMICOL COMMA BYTE INT STRTYPE LPAREN RPAREN LBRACK RBRACK LCURL LISTTYPE VOIDTYPE ASSIGN COMMENT MULTICOMMENT

%type <obj_node> st program statement expression declarations flow_control change_var comment func_dec variable_dec function_block arg_func_type function_line return value function_call arg_val range block condition step 
%type <end_node> comp
%type function_inp arg_func func_dec variable_dec datatype 

%left IDENT
%right LBRACK
%left PLUS MINUS
%left TIMES DIVIDE
%right ASSIGN
%nonassoc EQL NEQ LSS GTR LEQ GEQ

%start st


%%

st : START_OF_FILE { add('K', $1); } program { $$ = mknode($3, NULL, "start"); head = $$;  }
   ;

program : statement program { $$ = mknode($2, $1, "statement"); }
        | statement { $$ = mknode($1, NULL, "statement"); }
        ;

statement : declarations
          | expression
          | flow_control { $$ = mknode($1, NULL, "flow control"); }
          | change_var { $$ = mknode($1, NULL, "change variable"); }
          | comment { $$ = mknode(NULL, NULL, "comment"); } 
          ;


declarations : func_dec { $$ = mknode($1, NULL, "function declaration"); }
             | variable_dec { $$ = mknode($1, NULL, "variable declaration"); }
             ;


comment : COMMENT {}
        | MULTICOMMENT {} 
        ;

change_var : IDENT ASSIGN expression { $$ = mknode($3, NULL, $1); }
           ;

func_dec : DEF { add('K', $1); } arg_func_type IDENT LPAREN function_inp RPAREN
           LCURL function_block RCURL
         {
         $$ = mknode($9, NULL, $4);
         function_table[count_function_table].count_inp_datatypes = array_input_type_index;
         array_input_type_index = 0;
         add_func($4); 
         }
         ;

function_inp : arg_func
             | arg_func COMMA function_inp 
             | 
             ;

arg_func : arg_func_datatype IDENT 
         {
         printf("%d", count_function_table);
         function_table[count_function_table].input_datatypes[array_input_type_index] = (struct function_name_type *)malloc(sizeof(struct function_name_type));
         function_table[count_function_table].input_datatypes[array_input_type_index]->name = strdup($2);
         strcpy(function_table[count_function_table].input_datatypes[array_input_type_index]->arg_type, type);
         array_input_type_index++;
         }
         ;

arg_func_datatype : BYTE { insert_func_type("byte"); }
                  | INT { insert_func_type("int"); }
                  | STRTYPE { insert_func_type("string"); }
                  ;

arg_func_type : BYTE { insert_type("byte"); }
              | INT { insert_type("int"); }
              | STR { insert_type("string"); }
              | VOIDTYPE { insert_type("void"); }
              ;

function_block : function_line 
               | function_block function_line { $$ = mknode($1, $2, "function line"); }
               ;

function_line : statement 
              | return 
              ;

return : RTRN { add('K', $1); } expression { $$ = mknode($3, NULL, "return"); }
       ;

expression : expression PLUS expression { $$ = mknode($1, $3, $2); }
           | expression MINUS expression { $$ = mknode($1, $3, $2); }
           | expression TIMES expression { $$ = mknode($1, $3, $2); }
           | expression DIVIDE expression { $$ = mknode($1, $3, $2); }
           | LPAREN expression RPAREN { $$ = $2; }
           | value
           ;


value : IDENT { $$ = mknode(NULL, NULL, $1); }
      | NUMBER { $$ = mknode(NULL, NULL, $1); }
      | STR { $$ = mknode(NULL, NULL, $1); }
      | function_call
      ;

function_call : CALL IDENT LPAREN arg_val RPAREN
              {
              add('K', $1);
              $$ = mknode($4, NULL, $2);
              }
              | CALL CAPACITY LPAREN arg_val RPAREN
              {
              add('K', $1);
              $$ = mknode($4, NULL, $2);
              }
              | CALL LEN LPAREN arg_val RPAREN
              {
              add('K', $1);
              $$ = mknode($4, NULL, $2);
              }
              ;

arg_val : expression 
        | arg_val COMMA expression { $$ = mknode($1, $3, "function call argument"); }
        | { }
        ;


variable_dec : datatype IDENT { add('V', $2); } ASSIGN expression { $$ = mknode($5, NULL, $2); } 
             ;

datatype : BYTE { insert_type("byte"); }
         | INT { insert_type("int"); }
         | STRTYPE { insert_type("string"); }
         ;


flow_control : LOOP { add('K', $1); } LPAREN datatype IDENT { add('V', $5); } SEMICOL range RPAREN block
             {
             $$ = mknode($8, $10, $5);
             }
             | IF { add('K', $1); } LPAREN condition RPAREN block { $$ = mknode($4, $6, "if statement"); }
             ;

range: expression TO expression { $$ = mknode($1, $3, $2); }
     | expression TO expression SEMICOL step { $$ = mknode($1, mknode($3, $5, "step"), $2); }
     ;

step : expression 
     ;

condition : expression comp expression { $$ = mknode($1, $3, $2); }
          ;

comp : EQL | NEQ | LSS | GTR | LEQ | GEQ
     ;

block : LCURL program RCURL { $$ = $2; }
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
    yyparse();
    fclose(fp);

    out = fopen("out.txt", "w");

    int i = 0;

    fprintf(out, "\n\n");
    fprintf(out, "\nNAME   RET_DATATYPE   INP_DATATYPE \n");
    fprintf(out, "_______________________________________\n\n");
    for(i=0; i<count_function_table; i++) {
        fprintf(out, "%s\t%s\t\t", function_table[i].id_name, function_table[i].data_type);
        for (int a = 0; a < function_table[i].count_inp_datatypes; a++){
            fprintf(out, "%s\t%s, ", function_table[i].input_datatypes[a]->arg_type, function_table[i].input_datatypes[a]->name);
        }
        fprintf(out, "\n");
    }
    fprintf(out, "\n\n");

    fprintf(out, "\n\n");
    fprintf(out, "\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
    fprintf(out, "_______________________________________\n\n");
    i=0;
    for(i=0; i<count_symbol_table; i++) {
        fprintf(out, "%s\t%s\t%s\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].symbol_type, symbol_table[i].line_number);
    }
    fprintf(out, "\n\n");


    printtree(head);

    return 0;

}

void insert_func_type(char *type_to_insert){
    int ret = snprintf(func_type, 10, "%s", type_to_insert);
    if (ret < strlen(type)){
        yyerror("error inserting type");
    }
}

void insert_type(char *type_to_insert){
    int ret = snprintf(type, 10, "%s", type_to_insert);
    if (ret < strlen(func_type)){
        yyerror("error inserting type");
    }
}

int search(char *id){
    int i;
    for (i = count_symbol_table-1; i>= 0; i--){
        if (strcmp(symbol_table[i].id_name, id) == 0){
            return 1;
        }
    }
    return 0;
}


void add(char c, char *id){
    
    int found = search(id);
    if (c == 'K'){
        found = 0;
    }

    if (!found){
        symbol_table[count_symbol_table].id_name = strdup(id);
        symbol_table[count_symbol_table].line_number = input_file_line_no;
        switch (c){
        /*
        K keyword
        C consctant
        V variable
        F function dec
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

            case 'F':
                symbol_table[count_symbol_table].data_type = strdup(type);
                symbol_table[count_symbol_table].symbol_type = "Funtion dec";
                break;

            default:
                yyerror("symbol not found");
        }
        count_symbol_table++;
    }
    if (found && c == 'V'){
        yyerror("Multiple variable declarations aren't allowed");
    }
    if (found && c == 'F'){
        yyerror("Multiple fucntion declarations aren't allowed");
    }

}



int search_func(char *name){
    int i;
    for (i = count_function_table-1; i>= 0; i--){
        if (strcmp(function_table[i].id_name, name) == 0){
            return 1;
        }
    }
    return 0;
}

void add_func(char *name){
    int found = search_func(name);

    if (found){
        yyerror("Multiple function declarations aren't allowed");
    }

    strcpy(function_table[count_function_table].data_type, type);
    function_table[count_function_table].id_name = strdup(name);

    count_function_table++;
}

struct node *mknode(struct node *left, struct node *right, char *token){
    struct node *newnode = (struct node*)malloc(sizeof(struct node));
    char *newstr = (char*)malloc(strlen(token)+1);
    strcpy(newstr, token);

    newnode->left = left;
    newnode->right = right;
    newnode->token = newstr;

    return newnode;

}

void printtree(struct node *root){
    fprintf(out, "\n\n Inorder traversal of the Parse Tree: \n\n");
    if (root){
        printInorder(root);
    } else{
        fprintf(out, "invalid root");
    }
	fprintf(out, "\n\n");
}

void printInorder(struct node *tree) {
    fprintf(out, "%s\n", tree->token);
    fflush(stdout);
    if (tree->left){
        printInorder(tree->left);
    }
	if (tree->right) {
		printInorder(tree->right);
	}
}

