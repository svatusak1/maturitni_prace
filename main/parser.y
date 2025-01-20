%{
#include <stdio.h>
#include <string.h>


int yylex(void);
int yyerror(const char *);

extern FILE *yyin;

char type[10];
void add(char, char*);
void add_func(char*);
struct symbolDataType {
    char *data_type;
    char *id_name;
    char *type;
    int line_number;
} symbol_table[50];
int count_symbol_table = 0;

struct function_name_type{
    char *name;
    char type[10];
};

struct functionDataType {
    char *data_type;
    struct function_name_type *array_datatype[20];
    char *id_name;
} function_table[50];
int array_input_type_index = 0;
int count_function_table = 0;


extern int input_file_line_no;

void insert_type(char*);

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

%token <end_node> START_OF_FILE DEF IDENT RTRN 
%token  NUMBER STR REMLIST ADDLIST PLUS MINUS TIMES DIVIDE RCURL SEMICOL COMMA EQL NEQ LSS GTR LEQ GEQ CALL LOOP TO IF BYTE INT STRTYPE LPAREN RPAREN LBRACK RBRACK LCURL LISTTYPE VOIDTYPE ASSIGN CAPACITY LEN COMMENT MULTICOMMENT

%type <obj_node> st program statement expression declarations flow_control change_var comment func_dec variable_dec function_block arg_func_type return function_line 
%type   function_inp arg_func func_dec return variable_dec range block step condition function_call arg_val value 
%type datatype comp

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
          | expression { $$ = mknode($1, NULL, "expression"); }
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

change_var : IDENT ASSIGN expression { $$ = mknode($3, NULL, "change variable"); }
           ;

func_dec : DEF { add('K', $1); } arg_func_type IDENT { add_func($4); } LPAREN function_inp RPAREN
           LCURL function_block RCURL
         {
         $$ = mknode($10, NULL, $4);
         }
         ;

function_inp : arg_func
             | arg_func COMMA function_inp 
             | 
             ;

arg_func : arg_func_datatype IDENT
         { 
         strcpy(function_table[count_function_table].array_datatype[array_input_type_index]->type, type);
         function_table[count_function_table].array_datatype[array_input_type_index]->name = strdup($2);
         }
         ;


arg_func_datatype : BYTE { insert_type("byte"); }
                  | INT { insert_type("int"); }
                  | STRTYPE { insert_type("string"); }
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

return : RTRN expression { $$ = mknode($2, NULL, "return"); add('K', $1); }
       ;

expression : expression PLUS expression
           | expression MINUS expression
           | expression TIMES expression
           | expression DIVIDE expression
           | LPAREN expression RPAREN
           | value
           ;


value : IDENT
      | NUMBER
      | STR
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


variable_dec : datatype IDENT ASSIGN expression 
             ;

datatype : BYTE
         | INT
         | STRTYPE
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
    yyparse();
    fclose(fp);


    printf("\n\n");
    printf("\nNAME   RET_DATATYPE   INP_DATATYPE \n");
    printf("_______________________________________\n\n");
    int i=0;
    for(i=0; i<count_function_table; i++) {
        printf("%s\t%s\t%s\t", function_table[i].id_name, function_table[i].data_type);
        int a = 0;
        while (function_table[i].array_datatype[a]){
            printf("%s\t", function_table[i].array_datatype[a]);
        }
    }
    printf("\n\n");

    printf("\n\n");
    printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
    printf("_______________________________________\n\n");
    i=0;
    for(i=0; i<count_symbol_table; i++) {
        printf("%s\t%s\t%s\t\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type, symbol_table[i].line_number);
    }
    printf("\n\n");


    printtree(head);

    return 0;

}

void insert_type(char *type){
    int ret = snprintf(type, 10, "%s", type);
    if (ret < strlen(type)){
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

    if (!found){
        symbol_table[count_symbol_table].id_name = strdup(id);
        symbol_table[count_symbol_table].line_number = input_file_line_no;
        switch (c){
        /*
        K keyword
        C consctant
        V variable
        F function dec
        I function call / invoke
        */
            case 'K':
                symbol_table[count_symbol_table].data_type = "N/A";
                symbol_table[count_symbol_table].type = "Keyword";
                break;

            case 'C':
                symbol_table[count_symbol_table].data_type = "CONSTAT";
                symbol_table[count_symbol_table].type = "Constant";
                break;

            case 'V':
                symbol_table[count_symbol_table].data_type = strdup(type);
                symbol_table[count_symbol_table].type = "Variable";
                break;

            case 'F':
                symbol_table[count_symbol_table].data_type = strdup(type);
                symbol_table[count_symbol_table].type = "Funtion dec";
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

    function_table[count_function_table].id_name = strdup(name);
    function_table[count_function_table].data_type = strdup(type);

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
    printf("\n\n Inorder traversal of the Parse Tree: \n\n");
    if (root){
        printInorder(root);
    } else{
        printf("invalid root");
    }
	printf("\n\n");
}

void printInorder(struct node *tree) {
    printf("%s, ", tree->token);
    fflush(stdout);
    if (tree->left){
        printInorder(tree->left);
    }
	if (tree->right) {
		printInorder(tree->right);
	}
}

