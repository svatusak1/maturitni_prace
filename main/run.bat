bison -vdy parser_gen_only.y
flex grammar_gen_only.l
gcc y.tab.c lex.yy.c
a.exe
