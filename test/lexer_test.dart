import 'dart:math';

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
    final values = [
      '==',
      '>=',
      '<=',
      '!=',
      '&&',
      '||',
    ];
    Token token = lexer.getNextToken();

    int lineIndex = 0;

    for (int i = 0; token.type != TokenTypes.eof; i++) {
      expect(token.type, types[i]);
      expect(token.value, values[i]);
      expect(token.lineIndex, lineIndex);
      expect(token.lineNumber, 1);

      lineIndex += 2;

      token = lexer.getNextToken();
    }
  });

  test('literals and keywords test', () {
    final srcCode =
        'indentifier 123 "string" true false class fun if for while else null return var this super print';
    final lexer = Lexer(srcCode);
    final types = [
      TokenTypes.identifiers,
      TokenTypes.number,
      TokenTypes.string,
      TokenTypes.trueToken,
      TokenTypes.falseToken,
      TokenTypes.classToken,
      TokenTypes.function,
      TokenTypes.ifToken,
      TokenTypes.forToken,
      TokenTypes.whileToken,
      TokenTypes.elseToken,
      TokenTypes.nullToken,
      TokenTypes.returnToken,
      TokenTypes.varToken,
      TokenTypes.thisToken,
      TokenTypes.superToken,
      TokenTypes.printToken,
    ];
    final values = [
      'indentifier',
      '123',
      'string',
      'true',
      'false',
      'class',
      'fun',
      'if',
      'for',
      'while',
      'else',
      'null',
      'return',
      'var',
      'this',
      'super',
      'print',
    ];
    Token token = lexer.getNextToken();

    int lineIndex = 0;

    for (int i = 0; token.type != TokenTypes.eof; i++) {
      expect(token.type, types[i]);
      expect(token.value, values[i]);
      expect(token.lineIndex, lineIndex);
      expect(token.lineNumber, 1);

      lineIndex += values[i].length + 1;

      if (token.type == TokenTypes.string) {
        lineIndex += 2;
      }

      token = lexer.getNextToken();
    }
  });

  test('keywords with single char in the middle', () {
    final srcCode = 'print.return';
    final lexer = Lexer(srcCode);
    final types = [
      TokenTypes.printToken,
      TokenTypes.dot,
      TokenTypes.returnToken,
    ];
    final values = [
      'print',
      '.',
      'return',
    ];
    Token token = lexer.getNextToken();

    int lineIndex = 0;

    for (int i = 0; token.type != TokenTypes.eof; i++) {
      expect(token.type, types[i]);
      expect(token.value, values[i]);
      expect(token.lineIndex, lineIndex);
      expect(token.lineNumber, 1);

      lineIndex += values[i].length;

      token = lexer.getNextToken();
    }
  });

    test('identifier with a part of a keyword', () {
    final srcCode = 'thisVariable';
    final lexer = Lexer(srcCode);
    Token token = lexer.getNextToken();


      expect(token.type, TokenTypes.identifiers);
      expect(token.value, 'thisVariable');
      expect(token.lineIndex, 0);
      expect(token.lineNumber, 1);
    
  });

  test('random identifier without last letter trailing', () {
    final srcCode = 'abc';
    final lexer = Lexer(srcCode);

    Token token = lexer.getNextToken();

    expect(token.type, TokenTypes.identifiers);
    expect(token.value, 'abc');
    expect(token.lineNumber, 1);
    expect(token.lineIndex, 0);
  });

  test('empty source code', () {
    final srcCode = '';
    final lexer = Lexer(srcCode);

    Token token = lexer.getNextToken();

    expect(token.type, TokenTypes.eof);
    expect(token.value, '');
  });

  test('multiple dots with numbers test', () {
    final srcCode = '1.2.3.4.5';
    final lexer = Lexer(srcCode);
    final types = [
      TokenTypes.number,
      TokenTypes.dot,
      TokenTypes.number,
      TokenTypes.dot,
      TokenTypes.number,
    ];
    final values = [
      '1.2',
      '.',
      '3.4',
      '.',
      '5',
    ];

    Token token = lexer.getNextToken();

    int lineIndex = 0;

    for (int i = 0; token.type != TokenTypes.eof; i++) {
      expect(token.type, types[i]);
      expect(token.value, values[i]);
      expect(token.lineIndex, lineIndex);
      expect(token.lineNumber, 1);

      lineIndex += values[i].length;

      token = lexer.getNextToken();
    }



  });

  test('number decimals with zero test', () {
    final srcCode = '2.10 2.0 2. 02.0';
    final lexer = Lexer(srcCode);
    final types = [
      TokenTypes.number,
      TokenTypes.number,
      TokenTypes.number,
      TokenTypes.dot,
      TokenTypes.number,
    ];
    final values = [
      '2.1',
      '2.0',
      '2',
      '.',
      '2.0',
    ];
    Token token = lexer.getNextToken();

    int lineIndex = 0;

    for (int i = 0; token.type != TokenTypes.eof; i++) {
      expect(token.type, types[i]);
      expect(token.value, values[i]);
      expect(token.lineIndex, lineIndex);
      expect(token.lineNumber, 1);

      lineIndex += values[i].length + 1;

      if (token.value == '2.1') {
        lineIndex++;
      }

      if (token.value == '2') {
        lineIndex--;
      }

      token = lexer.getNextToken();
    }
  });
}
