bison -d parser.y
flex grammar.l
clang -std=c23 lex.yy.c parser.tab.c
a.exe
