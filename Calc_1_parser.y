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

%union
{
	float number;
	char variable;
	
	struct {
		float sum;
		int count;
	} avg;
}

%token PLUS MINUS MULT DIV POW EQ
%token T_MAX T_MIN T_SUM T_AVG T_EXIT
%token NL BR_ST BR_END COMMA

// TERMINALS ONLY!
%token <number> INT EXP
%token <variable> VAR

// NON-TERMINALS!
%type <number> operand line args_max args_min args_sum exp
%type <avg> args_avg

%{
	#include <stdlib.h>
	#include <stdio.h>
	#include <math.h>
	void yyerror(char *s);
	int yylex();
	extern FILE* yyin;

	float lookup[26];
%}

%left PLUS	/* Lower  precedence */
%left MULT	/* Higher precedence */
%right NEGATION
%left POW	/* Much higher precedence */
	
%%
head	:line head
        |T_EXIT NL           {return 0;}
		|

line	:operand NL { printf("%f\n", $1); }

operand :INT	{ $$ = $1; }
		|EXP	{ $$ = $1; }
		|VAR	{ $$ = lookup[$1-'a']; }
		|VAR EQ operand { 
			lookup[$1 - 'a'] = $3;
			$$ = $3;
			printf("%c = %f\n", $1, lookup[$1 - 'a']);
		}
		|operand PLUS operand { $$ = $1 + $3; }
		|operand MULT operand { $$ = $1 * $3; }
		|operand MINUS operand { $$ = $1 - $3; }
		|operand DIV operand { $$ = $1 / $3; }
		|operand POW operand { $$ = pow($1, $3); }
		|MINUS operand %prec NEGATION { $$ = -$2; }
		|BR_ST operand BR_END { $$ = $2 }
		|T_MAX BR_ST args_max BR_END { $$ = $3; }
		|T_MIN BR_ST args_min BR_END { $$ = $3; }
		|T_SUM BR_ST args_sum BR_END { $$ = $3; }
		|T_AVG BR_ST args_avg BR_END { $$ = $3.sum / ($3.count); }

args_max :args_max COMMA args_max { $$ = ($1 >= $3) ? $1 : $3; }
		|operand { $$ = $1; }

args_min :args_min COMMA args_min { $$ = ($1 <= $3) ? $1 : $3; }
		|operand { $$ = $1; }

args_sum :args_sum COMMA args_sum { $$ = $1 + $3; }
		|operand { $$ = $1; }

args_avg :operand { 
			$$.sum = $1; $$.count = 1; 
			printf("+ s:%f c:%d\n", $$.sum, $$.count);
		}
		|args_avg COMMA operand {
			$$.sum += $3;
			$$.count += 1;
			printf("* %f, %f, s:%f, c:%d\n", $1.sum, $3, $$.sum, $$.count);
		}

exp 	:EXP { $$ = $1; }
		|exp PLUS exp { $$ = $1 + $3; }
		|exp MINUS exp { $$ = $1 - $3; }
		|exp MULT exp { $$ = $1 * $3; }

	
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() 
{
    yyparse(); 
    return 0;
}