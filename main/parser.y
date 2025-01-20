%{
#include <stdio.h>
#include <string.h>


int yylex(void);
int yyerror(const char *);

extern FILE *yyin;

char type[10];
void add(char, char*);
struct symbolDataType {
    char * data_type;
    char * id_name;
    char * type;
    int line_number;
} symbol_table[50];
int count_symbol_table = 0;

struct functionDataType {
    char * data_type;
    char array_datatype[20][10];
    char * id_name;
} function_table[50];
int array_input_type_index = 0;
int count_function_table = 0;


extern int input_file_line_no;

void insert_type(char*);

struct node* mknode(struct node *left, struct node *right, char *token);

struct node{
    struct node *left;
    struct node *right;
    char *token;
};

struct node* head = NULL;
void printtree(struct node*);
void printInorder(struct node *);

%}

%union{
    struct node *obj_node;
    char end_node[100];
}

%token  NUMBER STR IDENT START_OF_FILE REMLIST ADDLIST PLUS MINUS TIMES DIVIDE RCURL SEMICOL COMMA EQL NEQ LSS GTR LEQ GEQ CALL DEF RTRN LOOP TO IF BYTE INT STRTYPE LPAREN RPAREN LBRACK RBRACK LCURL LISTTYPE VOIDTYPE ASSIGN CAPACITY LEN COMMENT MULTICOMMENT

%type expression st program statement declarations function_inp arg_func func_dec function_block return variable_dec change_val comment flow_control range block step condition function_line function_call arg_val value arg_func_type
%type datatype comp

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
        printf("%s\t%s\t%s\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type, symbol_table[i].line_number);
    }
    printf("\n\n");

    printtree(head);

    return 0;

}

void insert_type(char* type){
    int ret = snprintf(type, 10, "%s", type);
    if (ret < strlen(type)){
        yyerror("error inserting type");
    }
}

int search(char* id){
    int i;
    for (i = count_symbol_table-1; i>= 0; i--){
        if (strcmp(symbol_table[i].id_name, id) == 0){
            return 1;
        }
    }
    return 0;
}


void add(char c, char* id){
    
    int found = search(id);

    if (!found){
        symbol_table[count_symbol_table].id_name = id;
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
                symbol_table[count_symbol_table].data_type=strdup("N/A");
                symbol_table[count_symbol_table].type = "Keyword";
                break;

            case 'C':
                symbol_table[count_symbol_table].data_type = strdup("CONSTAT");
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
struct node* mknode(struct node *left, struct node *right, char *token){
    struct node* newnode = (struct node*)malloc(sizeof(struct node));
    char* newstr = (char*)malloc(strlen(token)+1);
    strcpy(newstr, token);

    newnode->left = left;
    newnode->right = right;
    newnode->token = newstr;

    return newnode;

}

void printtree(struct node* root){
    printf("\n\n Inorder traversal of the Parse Tree: \n\n");
    if (root){
        printInorder(root);
    } else{
        printf("invalid root");
    }
	printf("\n\n");
}

void printInorder(struct node *tree) {
	int i;
	if (tree->left) {
		printInorder(tree->left);
	}
	printf("%s, ", tree->token);
	if (tree->right) {
		printInorder(tree->right);
	}
}

