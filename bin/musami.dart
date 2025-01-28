import 'lexer/tokens.dart';
import 'lexer/lexer.dart';

void main(List<String> arguments) {
  final lexer = Lexer(
      '2+2'); //After a String, must there be a spcae? I think yes

  Token token = lexer.getNextToken();

  while (token.type != TokenTypes.eof) {
    print(token);
    token = lexer.getNextToken();
  }

  print("----------\nEnd of Source Code Buddy, Move Along!");
}

/*
  var a = 10;
  10.0
  "asdf"
  true

  fun a() {}

  class A {}
*/
