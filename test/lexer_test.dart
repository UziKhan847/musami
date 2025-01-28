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

   test('multi character test', () {
    final srcCode = '==>=<=!=&&||';
    final lexer = Lexer(srcCode);
    final types = [
      TokenTypes.equalEqual,
      TokenTypes.greaterThanEqualTo,
      TokenTypes.lessThanEqualTo,
      TokenTypes.notEqual,
      TokenTypes.and,
      TokenTypes.or,
    ];
    Token token = lexer.getNextToken();

    int x = 0;

    for (int i = 0; token.type != TokenTypes.eof; i += 2) {
      expect(token.type, types[x]);
      expect(token.value, srcCode[i] + srcCode[i + 1]);
      expect(token.lineIndex, i);
      expect(token.lineNumber, 1);

      x++;

      token = lexer.getNextToken();
    }
  });
}
