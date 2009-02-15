%{
%}

%token <string> STRING PROPIDENT
%token LPAR RPAR SEMI

%start <Sgf.collection> collection

%%

collection:
| col = gametree+ { col }

gametree:
| LPAR seq = sequence gmt = gametree* RPAR { (seq, gmt) }

sequence:
| seq = node+ { seq }

node:
| SEMI prop = property* { prop }

property:
| pi = PROPIDENT pv = propvalue+ { (pi, pv) }

propvalue:
| s = STRING { s }
