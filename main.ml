let lexbuf = Lexing.from_channel stdin

let ast = Parser.input Lexer.main lexbuf
