#include "output.hpp"
#include <iostream>

static const std::string token_names[] = {
        "__FILLER_FOR_ZERO",
        "VOID",
        "INT",
        "BYTE",
        "BOOL",
        "AND",
        "OR",
        "NOT",
        "TRUE",
        "FALSE",
        "RETURN",
        "IF",
        "ELSE",
        "WHILE",
        "BREAK",
        "CONTINUE",
        "SC",
        "COMMA",
        "LPAREN",
        "RPAREN",
        "LBRACE",
        "RBRACE",
        "ASSIGN",
        "RELOP",
        "BINOP",
        "COMMENT",
        "ID",
        "NUM",
        "NUM_B",
        "STRING"
};

char* my_string;

void output::printToken(int lineno, enum tokentype token, const char *value) {
    if (token == COMMENT) {
        std::cout << lineno << " COMMENT //" << std::endl;
    } else if (token == STRING) {
        std::cout << lineno << " " << token_names[token] << " " << my_string << std::endl;
        freeString();
    } else {
        std::cout << lineno << " " << token_names[token] << " " << value << std::endl;
    }
}

void checkerror(enum tokentype token,const char *value){
    if (token == UNKNOWN )
        output::errorUnknownChar(value[0]);
    else if(token == UNCLOSED) 
        output::errorUnclosedString();
    else if(token == UNDEFINED)
        output::errorUndefinedEscape(value);
}

void output::errorUnknownChar(char c) {
    std::cout << "ERROR: Unknown character " << c << std::endl;
    exit(0);
}

void output::errorUnclosedString() {
    std::cout << "ERROR: Unclosed string" << std::endl;
    exit(0);
}

void output::errorUndefinedEscape(const char *sequence) {
    std::cout << "ERROR: Undefined escape sequence " << sequence << std::endl;
    exit(0);
}

void allocString()
{
    my_string = (char*)malloc(1024 * sizeof(char));
}

void freeString()
{
    my_string[0] = '\0';
    free(my_string);
}
