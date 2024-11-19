%{
/* Declaration Section */
#include <stdio.h>
#include "tokens.hpp"
%}

%option yylineno
%option noyywrap

%%
"void"           {return VOID; }

%%

