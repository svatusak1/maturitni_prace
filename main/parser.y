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

void tree_free(struct node *, FILE *);
%}

%union{
    char *node_type;
    struct node *node_obj;
}

%token START_OF_FILE
%token <node_type> REMLIST ADDLIST PLUS MINUS TIMES DIVIDE RCURL SEMICOL COMMA EQL NEQ LSS GTR LEQ GEQ
CALL DEF RTRN LOOP TO IF BYTE INT STRTYPE LPAREN RPAREN LBRACK RBRACK LCURL LISTTYPE VOIDTYPE ASSIGN CAPACITY LEN COMMENT MULTICOMMENT
IDENT NUMBER STR 

%type <node_obj> st program statement func_inp arg_func_type arg_func_list_type arg_func func_dec function_block return expression

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

statement : declarations
          | expression
          | flow_control
          | change_val
          | comment
          ;


declarations : func_dec
             | variable_dec
             | list_dec
             ;


comment : COMMENT
        | MULTICOMMENT
        ;

change_val : IDENT ASSIGN expression
           |  list_change
           ;

list_change : IDENT ADDLIST expression
            | IDENT REMLIST expression
            ;

func_dec : DEF arg_func_type IDENT LPAREN func_inp RPAREN 
             LCURL function_block RCURL
             { 
                $$ = mknode(mknode(NULL, NULL, $3), mknode($2, mknode($5, $8, "function body, input"), "function parameters"), "function dec"); 
             }
             ;

func_inp : arg_func
         | arg_func COMMA func_inp { $$ = mknode($3, $1, "function args"); }
         | { $$ = mknode(NULL, NULL, "empty arg"); }
         ;

arg_func : arg_func_type IDENT { $$ = mknode($1, mknode(NULL, NULL, $2), "function argument"); }
         ;


arg_func_type : BYTE { $$ = mknode(NULL, NULL, $1); }
              | INT { $$ = mknode(NULL, NULL, $1); }
              | STRTYPE { $$ = mknode(NULL, NULL, $1); }
              | arg_func_list_type { $$ = mknode($1, NULL, "list type"); }
              | VOIDTYPE { $$ = mknode(NULL, NULL, $1); }
              ;

arg_func_list_type : LISTTYPE arg_func_type { $$ = mknode($2, NULL, $1); }
                   ;

function_block : function_line
               | function_block function_line 
               ;

function_line : statement
              | return
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
               $$ = mknode(NULL, NULL, yylval.node_type); 
           }
           | NUMBER 
           {
               $$ = mknode(NULL, NULL, yylval.node_type); 
           }
           | STR 
           {
               $$ = mknode(NULL, NULL, yylval.node_type); 
           }
           | function_call
           | list_indentation
           ;

function_call : CALL IDENT LPAREN arg_val RPAREN 
              | CALL CAPACITY LPAREN arg_val RPAREN 
              | CALL LEN LPAREN arg_val RPAREN 
              ;

arg_val : expression
        | arg_val COMMA expression
        | {}
        ;


variable_dec : datatype IDENT ASSIGN expression 
          ;

datatype : BYTE | INT | STRTYPE | list_type
         ;

list_type : LISTTYPE LBRACK expression LBRACK datatype
          ;

list_dec : LISTTYPE LBRACK expression RBRACK datatype IDENT ASSIGN LBRACK elem_list RBRACK 
          
         ;

elem_list : expression
          | elem_list COMMA expression
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

list_indentation : IDENT LBRACK expression RBRACK 
                 ;

%%

int main(void) {
    FILE *fp;
    fp = fopen("test.rog","r");
    yyin = fp;
    yyparse();

    fp = fopen("out.txt", "w");
    tree_free(head, fp);
    fclose(fp);

}

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

void tree_free(struct node *node, FILE *fp) {
    fprintf(fp, node->token);
    fprintf(fp, "    ");
    fprintf(fp, "%p", node);
    fprintf(fp, "    ");
    fprintf(fp, "%p", node->left);
    fprintf(fp, "    ");
    fprintf(fp, "%p", node->right);
    fprintf(fp, "\n");
    fflush(fp);
    printf(node->token);
    printf("\n");
    fflush(stdout);
    if (node->left){
        tree_free(node->left, fp);
    }
    if (node->right){
        tree_free(node->right, fp);
    }
}
