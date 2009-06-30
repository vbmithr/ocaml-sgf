%{

open Ast

%}

%token<string> PN PC
%token LPAR RPAR SEMI EOF

%start <Ast.collection> collection

%%

collection:
| col = gametree+ EOF
    { col }

gametree:
| LPAR gt = gametree+ RPAR
    { GT gt }
| LPAR seq = sequence RPAR
    { Seq seq }

sequence:
| seq = node+
    { seq }

node:
| SEMI pl = property*
    { pl }

property:
| name = PN vl = value+
    { { prop_name  = name;
        prop_value = vl } }

value:
| s = PC { s }
