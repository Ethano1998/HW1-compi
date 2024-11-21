#include "tokens.hpp"
#include "output.hpp"

int main() {
    enum tokentype token;

    // read tokens until the end of file is reached
    while ((token = static_cast<tokentype>(yylex()))) {
        checkerror(token,yytext);
        output::printToken(yylineno, token, yytext);
    }
    return 0;
}