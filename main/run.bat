bison -d parser.y
flex grammar.l
clang lex.yy.c parser.tab.c
a.exe
