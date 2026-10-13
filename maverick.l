%{
/* Maverick lexer (Flex)
   Maverick is a tiny line-based language: no braces, no semicolons.
   Keywords: begin, finish, int, say, if, else
   Every token has its own rule, so Bison can be added later.
   Output columns: line number, token name, lexeme.            */
#include <stdio.h>

int total = 0;

#define SHOW(category) { total++; printf("Line %-3d | %-10s | %s\n", yylineno, category, yytext); }
%}

%option noyywrap
%option yylineno

DIGIT   [0-9]
LETTER  [a-zA-Z_]

%%

"//".*                          { /* comment: skip */ }

"if"                            { SHOW("KEYWORD"); }
"else"                          { SHOW("KEYWORD"); }
"int"                           { SHOW("KEYWORD"); }
"while"                         { SHOW("KEYWORD"); }
"print"                         { SHOW("KEYWORD"); }

{DIGIT}+                        { SHOW("NUMBER"); }
{LETTER}({LETTER}|{DIGIT})*     { SHOW("IDENTIFIER"); }
\"[^\"\n]*\"                    { SHOW("STRING"); }

"=="|"!="|"<="|">="             { SHOW("OPERATOR"); }
"="|"+"|"-"|"*"|"/"|"<"|">"     { SHOW("OPERATOR"); }

"("|")"|"{"|"}"|";"|","         { SHOW("DELIMITER"); }

[ \t\r\n]+                      { /* skip whitespace */ }

.                               { printf("Line %-3d | %-10s | %s\n", yylineno, "ERROR", yytext); }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("Cannot open file %s\n", argv[1]);
            return 1;
        }
    }
    printf("=== Maverick Lexer ===\n");
    yylex();
    printf("=== Total tokens: %d ===\n", total);
    return 0;
}
