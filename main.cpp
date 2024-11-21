#include "tokens.hpp"
#include "output.hpp"

int main() {
    enum tokentype token;
    char* my_string = new char[1024];

    // read tokens until the end of file is reached
    while ((token = static_cast<tokentype>(yylex()))) {
        // your code here
        output::printToken(yylineno, token, yytext);
    }
    delete my_string;
    return 0;
}