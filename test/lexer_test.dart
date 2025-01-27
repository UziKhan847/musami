
import 'package:test/test.dart';

import '../bin/lexer/lexer.dart';
import '../bin/lexer/tokens.dart';

void main() {
  test('single character test', () {
    final srcCode = '(){}[],.;=+-*/><!?:';
    final lexer = Lexer(srcCode);
    final types = [
      TokenTypes.leftParen,
      TokenTypes.rightParen,
      TokenTypes.leftBrace,
      TokenTypes.rightBrace,
      TokenTypes.leftBracket,
      TokenTypes.rightBracket,
      TokenTypes.comma,
      TokenTypes.dot,
      TokenTypes.semicolon,
      TokenTypes.equal,
      TokenTypes.plus,
      TokenTypes.minus,
      TokenTypes.multiplication,
      TokenTypes.division,
      TokenTypes.greaterThan,
      TokenTypes.lessThan,
      TokenTypes.not,
      TokenTypes.questionMark,
      TokenTypes.colon
    ];
    Token token = lexer.getNextToken();

    for (int i = 0; token.type != TokenTypes.eof; i++) {
      expect(token.type, types[i]);
      expect(token.value, srcCode[i]);
      expect(token.lineIndex, i);
      expect(token.lineNumber, 1);

      token = lexer.getNextToken();
    }
  });
}
