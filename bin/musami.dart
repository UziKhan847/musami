import 'lexer/tokens.dart';
import 'lexer/lexer.dart';

void main(List<String> arguments) {
  final lexer = Lexer(' " \asd " ');

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
