%{
/* Declaration Section */
#include <stdio.h>
#include <stdlib.h>
#include "output.hpp"

int i;

%}

%option yylineno
%option noyywrap

%x STR
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


\"                    {allocString(); i = 0;
                        BEGIN(STR);  }
<STR>[^\\\n\r\"]     {my_string[i]=yytext[0];
                                i=i+1;}
<STR>\\          {BEGIN(BACKSLASH); }
<STR><<EOF>>       { freeString();
                       output::errorUnclosedString(); }
<STR>\"             {BEGIN(INITIAL); my_string[i] = '\0'; i = i + 1;
                        return STRING;}
<STR>[\n\r]             {output::errorUnclosedString();}
<BACKSLASH>x[2-6][0-9A-Fa-f]|x7[0-9A-Ea-e]   {BEGIN(STR); 
                                                unsigned int val;
                                                sscanf(yytext + 1, "%2x", &val); 
                                                char hexChar = (char)val;
                                                my_string[i] = hexChar;
                                                          i = i + 1;   }
<BACKSLASH>n                                  {BEGIN(STR); 
                                                my_string[i] = '\n';  i = i + 1;}  
<BACKSLASH>r                                  {BEGIN(STR); 
                                                 my_string[i] = '\r'; i = i + 1;}
<BACKSLASH>t                                 {BEGIN(STR); 
                                                 my_string[i] = '\t'; i = i + 1;}
<BACKSLASH>0                                  {BEGIN(STR); 
                                                 my_string[i] = '\0'; i = i + 1;}
<BACKSLASH>\"                                  {BEGIN(STR); 
                                                 my_string[i] = '\"'; i = i + 1;}
<BACKSLASH>\\                                  {BEGIN(STR); 
                                                 my_string[i] = '\\'; i = i + 1;}                                                         
<BACKSLASH>x[^\"]?[^\"]?       {output::errorUndefinedEscape(yytext);}
<BACKSLASH>.    {output::errorUndefinedEscape(yytext);}
[ \n\t\r]               { }
.               {output::errorUnknownChar(yytext[0]);}      


%%
