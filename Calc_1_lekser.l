/**************************************
  IMPORTANT!
  
  Make sure the folder you have unzipped the files has NO WHITE CHARs in path!

  Make sure your compiler knows where to find 
  flex and yacc applications!
  1. Right click on the name of your project in Solution Explorer.
  2. Click Properties.
  3. In Configuration Properties click VC++ Directories
  4. In right window edit Executable Directories -- add the path
     to folder /gnu/bin. 
  5. That's all folks!
 
*/


%option noyywrap

%{
	#include <stdlib.h> 
	#include "parser.h"
%}
 
%%
([0-9]+\.[0-9]+) {
	yylval.number = atof(yytext);
	return EXP;
}
[0-9]+		{ 
	yylval.number = (float)atoi(yytext);
	return INT; 
}
"+"			return PLUS;
"-"			return MINUS;
"*"			return MULT;
"/"			return DIV;
"("			return BR_ST;
")"			return BR_END;
"^"			return POW;
"="			return EQ;
"max"		return T_MAX;
"min"		return T_MIN;
"sum"		return T_SUM;
"avg"		return T_AVG;
","			return COMMA;
"ex"		return T_EXIT;
[a-z] {
	yylval.variable = *yytext;
	return VAR;
}
\n			return NL;
.			/* ignore */
%%