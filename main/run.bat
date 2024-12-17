bison -vdyg parser.y
flex grammar.l
gcc y.tab.c lex.yy.c
a.exe
