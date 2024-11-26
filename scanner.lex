%{
/* Declaration Section */
#include <stdio.h>
#include <stdlib.h>
#include "output.hpp"

%}

%option yylineno
%option noyywrap

%x STR
%x BACKSLASH
%x TERM

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
                        BEGIN(STR);  }
<STR>[^\\\n\r\"]*     {strcat(my_string, yytext);}
<STR>\\          {BEGIN(BACKSLASH); }
<STR><<EOF>>       { freeString();
                        return UNCLOSED; }
<STR>\"             {BEGIN(INITIAL);
                        return STRING;}
<STR>[\n\r]             {return UNCLOSED;}
<BACKSLASH>x[2-6][0-9A-Fa-f]|x7[0-9A-Ea-e]   {BEGIN(STR); 
                                                unsigned int val;
                                                sscanf(yytext + 1, "%2x", &val); 
                                                char hexChar[2] = { (char)val, '\0' };
                                                strcat(my_string, hexChar);}
<BACKSLASH>n                                  {BEGIN(STR); 
                                                strcat(my_string,"\n");}  
<BACKSLASH>r                                  {BEGIN(STR); 
                                                strcat(my_string,"\r");}
<BACKSLASH>t                                 {BEGIN(STR); 
                                                strcat(my_string,"\t");}
<BACKSLASH>0                                  {BEGIN(TERM); 
                                                return STRING;}
<BACKSLASH>\"                                  {BEGIN(STR); 
                                                strcat(my_string,"\"");} 
<BACKSLASH>\\                                  {BEGIN(STR); 
                                                strcat(my_string,"\\");}                                                         
<BACKSLASH>x[^\"]?[^\"]?       {return UNDEFINED;}
<BACKSLASH>.    {return UNDEFINED;}

<TERM>[^\"]              { }
<TERM>\"                {BEGIN(INITIAL);}
[ \n\t\r]               { }
.               {return UNKNOWN;}      


%%
