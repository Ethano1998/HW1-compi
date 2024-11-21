%{
/* Declaration Section */
#include <stdio.h>
#include <stdlib.h>
#include "output.hpp"

%}

%option yylineno
%option noyywrap

%x STRING
%x BACKSLASH
%x BACKSLASH

%%
void           {return VOID; }
int           {return INT; }
byte           {return BYTE; }
bool           {return BOOL; }
and           {return AND; }
or           {return OR; }
not           {return NOT; }
true           {return TRUE; }
false           {return FALSE; }
return           {return RETURN; }
if           {return IF; }
else           {return ELSE; }
while         {return WHILE;}
break         {return BREAK;}
continue      {return CONTINUE;}
;             {return SC;}
,             {return COMMA;}
\(             {return LPAREN;}
\)             {return RPAREN;}
\{             {return LBRACE;}
\}             {return RBRACE;}
=             {return ASSIGN;}
==|!=|<|>|<=|>=     {return RELOP;}
\+|\-|\*|\/     {return BINOP;}       
[1-9][0-9]*|0     {return NUM;}
[1-9][0-9]*b|0b {return NUM_B;}       
\/\/[^\n\r\t]*           {return COMMENT; }
[a-zA-Z][a-zA-Z0-9]*     {return ID; }


\"                    {allocString();
                        BEGIN(STRING);  }
<STRING>[^\\\n\r\"]*     {strcat(my_string, yytext);}
<STRING>\\          {BEGIN(BACKSLASH);  }
<STRING><<EOF>>       { freeString();
                    printf("End of file reached\n"); }
<STRING>\"             {return STRING;
                        BEGIN(INITIAL);}
<BACKSLASH>[nrt0\"\\]|x[2-6][0-9A-Fa-f]|x7[0-9A-Ea-e]   {BEGIN(STRING); return NUM;}
<BACKSLASH>.+    {return UNDEFINED;}      
[ \n\t\r]               { }

%%
