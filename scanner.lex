%{
/* Declaration Section */
#include <stdio.h>
#include "output.hpp"
%}

%option yylineno
%option noyywrap

%%
"void"           {return VOID; }
"int"           {return INT; }
"byte"           {return BYTE; }
"bool"           {return BOOL; }
"and"           {return AND; }
"or"           {return OR; }
"not"           {return NOT; }
"true"           {return TRUE; }
"false"           {return FALSE; }
"return"           {return RETURN; }
"if"           {return IF; }
"else"           {return ELSE; }
\/\/.*           {return COMMENT; }
[a-zA-Z][a-zA-Z0-9]*     {return ID; }

.               { }

%%

