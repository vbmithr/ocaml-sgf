%{
open Ast
%}

%token<string> PROPNAME PROPCONTENT
%token LPAR RPAR SEMI EOF

%start <Ast.collection> collection

%%

collection:
| col = gametree+ EOF { (col:collection) }

gametree:
| LPAR seq = sequence RPAR { Leaf seq }
| LPAR seq = sequence gt = gametree+ RPAR { Node (seq, gt) }

sequence:
| seq = node+ { (seq:sequence) }

node:
| SEMI pl = property+ { (pl:node) }

property:
| name = PROPNAME vl = PROPCONTENT+ { property_of_tuple name vl }
