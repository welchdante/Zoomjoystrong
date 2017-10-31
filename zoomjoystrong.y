%{
#include <stdio.h>
#include <stdlib.h>
#include "zoomjoystrong.h"
int yyerror(char * s);
extern char* yytext;
%}


%union{
    int intValue;
    float floatValue;
    char *stringValue;
}

%token END 
%token END_STATEMENT 
%token POINT 
%token LINE 
%token CIRCLE
%token RECTANGLE
%token SET_COLOR 
%token <intValue> INT
%token <floatValue> FLOAT

%%

program: statement_list end;

statement_list:    statement
|                  statement statement_list
;

statement:    point
|             line
|             circle
|             rectangle
|             set_color
;

set_color:    SET_COLOR INT INT INT END_STATEMENT         
{
    //error checking the RGB values
    if($2 >= 0 && $2 <=255 && $3 >= 0 && $3 <=255 && $4 >= 0 && $4 <=255){
        set_color($2,$3,$4); 
    }
    else{
        printf("Please enter RGB values in the range [0,255]\n");
    }
};

point:    POINT INT INT END_STATEMENT                 
{ 
    //error checking the bounds
    if($2 >= 0 && $2 <= WIDTH && $3 >=0 && $3 <=HEIGHT){
        point($2,$3);
    }
    else{
        printf("Please enter a point within the width and height\n");
    }
};

line:    LINE INT INT INT INT END_STATEMENT          
{ 
    //error checking the bounds
    if($2 >= 0 && $2 <= WIDTH &&  $3 >= 0 && $3 <= HEIGHT){
        line($2,$3,$4,$5); 
    }
    else{
        printf("Please enter a coordinate that starts within the width and height\n");
    }
};

circle:    CIRCLE INT INT INT END_STATEMENT            
{ 
    //error checking the bounds and radius
    if($2 >= 0 && $2 <= WIDTH && $3 >= 0 && $3 <=HEIGHT && $4 >= 0){
        circle($2,$3,$4); 
    }
    else{
        printf("Please enter a coordinate that starts within the width and height or make sure the radius is positive\n");
    }
};

rectangle:    RECTANGLE INT INT INT INT END_STATEMENT     
{
    //error checking the bounds
    if($2 >= 0 && $2 <= WIDTH &&  $3 >= 0 && $3 <= HEIGHT){
        rectangle($2,$3,$4,$5);
    }
    else{
        printf("Please enter a coordinate that starts within the grid\n");
    }
};

end:    END END_STATEMENT                        
{
    finish(); 
    return 0;
}
;

%%

extern FILE *yyin;

int main(int argc, char** argv)
{
    setup();
    yyin = fopen(argv[1], "r");
    yyparse();
    return 0;
}

/*
 * Generates an error if need be   
*/
int yyerror (char *s)
{
    printf("%s\n%s\n",s,yytext);
    return 1;
}

