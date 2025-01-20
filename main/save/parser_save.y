%{
#include <stdio.h>
#include <string.h>

int yylex(void);
int yyerror(const char *);

extern FILE *yyin;

struct node *mknode(struct node*, struct node*, char *);

struct node { 
    struct node *left; 
    struct node *right; 
    char *token; 
};
struct node *head;

void tree_free(struct node *);
%}

%union{
    char *node_type;
    struct node *node_obj;
}

%token START_OF_FILE
%token <node_type> REMLIST ADDLIST PLUS MINUS TIMES DIVIDE RCURL SEMICOL COMMA EQL NEQ LSS GTR LEQ GEQ
%token <node_type> CALL DEF RTRN LOOP TO IF BYTE INT STRTYPE LPAREN RPAREN LBRACK RBRACK LCURL LISTTYPE VOIDTYPE ASSIGN CAPACITY LEN COMMENT MULTICOMMENT
%token <node_type> IDENT NUMBER STR 

%type <node_obj> st program statement declarations
%type <node_obj> function_inp arg_func_type arg_func_list_type arg_func func_dec function_block return 
%type <node_obj> expression variable_dec change_val list_change comment
%type <node_obj> list_type datatype list_dec elem_list list_indentation
%type <node_obj> flow_control range block step condition function_line function_call arg_val

%left IDENT
%right LBRACK
%left PLUS MINUS
%left TIMES DIVIDE
%right ASSIGN
%nonassoc EQL NEQ LSS GTR LEQ GEQ

%start st


%%

st : START_OF_FILE program { $$ = mknode($2, NULL, "ENTRY"); head = $$; }
   ;

program : statement program { $$ = mknode($1, $2, "statement"); }
        | statement { $$ = $1; }
        ;

statement : declarations { $$ = $1; }
          | expression { $$ = $1; }
          | flow_control { $$ = $1; }
          | change_val { $$ = $1; }
          | comment { $$ = $1; }
          ;


declarations : func_dec { $$ = $1; }
             | variable_dec { $$ = $1; }
             | list_dec { $$ = $1; }
             ;


comment : COMMENT { $$ = mknode(NULL, NULL, "comment"); }
        | MULTICOMMENT { $$ = mknode(NULL, NULL, "comment"); }
        ;

change_val : IDENT ASSIGN expression { $$ = mknode($3, mknode(NULL, NULL, $1), "change val"); }
           |  list_change { $$ = $1; }
           ;

list_change : IDENT ADDLIST expression {$$ = mknode(mknode(NULL, NULL, $1), $3, "add to list");}
            | IDENT REMLIST expression {$$ = mknode(mknode(NULL, NULL, $1), $3, "remove from list");}
            ;

func_dec : DEF arg_func_type IDENT LPAREN function_inp RPAREN 
             LCURL function_block RCURL
             { 
                $$ = mknode(mknode(NULL, NULL, $3), mknode($2, mknode($5, $8, "function body, input"), "function parameters"), "function dec"); 
             }
             ;

function_inp : arg_func
             | arg_func COMMA function_inp { $$ = mknode($3, $1, "function args"); }
             | { $$ = mknode(NULL, NULL, "empty arg"); }
             ;

arg_func : arg_func_type IDENT { $$ = mknode($1, mknode(NULL, NULL, $2), "function argument"); }
         ;


arg_func_type : BYTE { $$ = mknode(NULL, NULL, "byte"); }
              | INT { $$ = mknode(NULL, NULL, "int"); }
              | STRTYPE { $$ = mknode(NULL, NULL, "string"); }
              | arg_func_list_type { $$ = mknode($1, NULL, "list type"); }
              | VOIDTYPE { $$ = mknode(NULL, NULL, "void"); }
              ;

arg_func_list_type : LISTTYPE arg_func_type { $$ = mknode($2, NULL, "list type"); }
                   ;

function_block : function_line { $$ = $1; }
               | function_block function_line { $$ = mknode($1, $2, "function block"); }
               ;

function_line : statement { $$ = $1; }
              | return { $$ = $1; }
              ;

return : RTRN expression { $$ = mknode($2, NULL, "return"); }
              ;

expression : expression PLUS expression { $$ = mknode($1, $3, "+"); }
           | expression MINUS expression { $$ = mknode($1, $3, "+"); }
           | expression TIMES expression { $$ = mknode($1, $3, "+"); }
           | expression DIVIDE expression { $$ = mknode($1, $3, "+"); }
           | LPAREN expression RPAREN { $$ = mknode($2, NULL, "expression in paren"); }
           | IDENT 
           {
               $$ = mknode(NULL, NULL, $1); 
           }
           | NUMBER 
           {
               $$ = mknode(NULL, NULL, $1); 
           }
           | STR 
           {
               $$ = mknode(NULL, NULL, $1); 
           }
           | function_call { $$ = $1; }
           | list_indentation { $$ = $1; }
           ;

function_call : CALL IDENT LPAREN arg_val RPAREN { $$ = mknode($4, mknode(NULL, NULL, $2), "func call"); }
              | CALL CAPACITY LPAREN arg_val RPAREN { $$ = mknode($4, NULL, "capacity call"); }
              | CALL LEN LPAREN arg_val RPAREN  { $$ = mknode($4, NULL, "len call"); }
              ;

arg_val : expression {$$ = $1; }
        | arg_val COMMA expression { $$ = mknode($1, $3, "arg vals"); }
        | {}
        ;


variable_dec : datatype IDENT ASSIGN expression 
             { $$ = mknode($1, $4, $2); }
          ;

datatype : BYTE { $$ = mknode(NULL, NULL, "byte"); }
         | INT { $$ = mknode(NULL, NULL, "int"); }
         | STRTYPE { $$ = mknode(NULL, NULL, "string"); }
         | list_type{ $$ = $1; }
         ;

list_type : LISTTYPE LBRACK expression LBRACK datatype
          { $$ = mknode($3, $5, "list type"); }
          ;

list_dec : LISTTYPE LBRACK expression RBRACK datatype IDENT ASSIGN LBRACK elem_list RBRACK 
         { $$ = mknode(mknode(mknode($3, $5, "size, datatype"), $9, "list spec"), mknode(NULL, NULL, $6), "list dec"); }
          
         ;

elem_list : expression { $$ = $1; }
          | elem_list COMMA expression { $$ = mknode($1, $3, "elem list"); }
          ;

flow_control : LOOP LPAREN datatype IDENT SEMICOL range RPAREN block
             { $$ = mknode(mknode(mknode($3, NULL, $4), $6, "range"), $8, "loop"); }
             | IF LPAREN condition RPAREN block 
             { $$ = mknode($3, $5, "if statement"); }
             ;

range: expression TO expression { $$ = mknode($1, $3, "range"); }
     | expression TO expression SEMICOL step { $$ = mknode(mknode($1, $3, "range"), $5, "range with step"); }
     ;

step : expression { $$ = $1; }
     ;

condition : expression comp expression { $$ = mknode($1, $3, "condition"); }
          ;

comp : EQL | NEQ | LSS | GTR | LEQ | GEQ
     ;

block : LCURL program RCURL { $$ = $2; }
      ;

list_indentation : IDENT LBRACK expression RBRACK { $$ = mknode($3, NULL, $1); }
                 ;

%%

int yyerror(const char *s)
{
    fprintf(stderr,"%s\n",s);
}

int yywrap(){
    return 1;
}

struct node *mknode(struct node *left, struct node *right, char *token) {	
	struct node *newnode = (struct node *)malloc(sizeof(struct node));
    char *newstr = (char *)malloc(strlen(token)+1);
	strcpy(newstr, token);
	newnode->left = left;
	newnode->right = right;
	newnode->token = newstr;
	return newnode;
}

void tree_free(struct node *node) {
    printf(node->token);
    printf("\n");
    fflush(stdout);
    if (node->left){
        tree_free(node->left);
    }
    if (node->right){
        tree_free(node->right);
    }
}

int main(void) {
    FILE *fp;
    fp = fopen("test.rog","r");
    yyin = fp;
    yyparse();
    fclose(fp);

    tree_free(head);

}
