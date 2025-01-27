import 'tokens.dart';

class Error implements Exception {

  Error(this.currentLine, this.lineIndex, this.message);

  String message;
  int currentLine;
  int lineIndex;

  @override
  String toString() => "Error on Line $currentLine, Index $lineIndex. $message";
}


class Lexer {
  Lexer(this.sourceCode);

  final String sourceCode;
  int currentLine = 1;
  int lineIndex = 0;
  int currentIndex = 0;
  late String currentChar = sourceCode[currentIndex];

  void advance() {
    if (currentIndex < sourceCode.length - 1) {
      currentIndex++;
      lineIndex++;
      currentChar = sourceCode[currentIndex];
    } else {
      currentIndex++;
    }
  }

  String peak() {
    if (currentIndex < sourceCode.length - 1) {
      return sourceCode[currentIndex + 1];
    }
    return "End of Source Code";
  }

  Token collectIdentifier() {
    final start = lineIndex;
    final nextChar = peak();

    String id = sourceCode[currentIndex];
    advance();

    if (!nextChar.contains(RegExp('[\n ]'))) {

      if (currentIndex < sourceCode.length) {
        while (currentChar.contains(RegExp('[A-Za-z_0-9]'))) {
          id += currentChar;

          if (currentIndex >= sourceCode.length - 1) {
            currentIndex++;
            break;
          }

          advance();
        }
      }
    }

    return Token(
      lineNumber: currentLine,
      lineIndex: start,
      type: TokenTypes.identifiers,
      value: id,
    );
  }

    Token collectNumber() {
    final start = lineIndex;
    final nextChar = peak();

    String number = sourceCode[currentIndex];
    advance();

    if (!nextChar.contains(RegExp('[\n ]'))) {
      if (currentIndex < sourceCode.length) {
        while (currentChar.contains(RegExp('[0-9]'))) {
          number += currentChar;

          if (currentIndex >= sourceCode.length - 1) {
            currentIndex++;
            break;
          }

          advance();
        }
      }
    }

    return Token(
      lineNumber: currentLine,
      lineIndex: start,
      type: TokenTypes.identifiers,
      value: number,
    );
  }

  Token collectString() {
    final start = lineIndex;
    final startLine = currentLine;
    String openingQuote = currentChar;

    String string = '';

    advance();

    while (currentChar != openingQuote) {
      if (currentChar == '\\') {
        currentIndex++;
        currentChar = sourceCode[currentIndex];

        if (currentChar == 'n') {
          string += '\n';

          currentIndex++;
          currentLine++;
          lineIndex = 0;
          currentChar = sourceCode[currentIndex];
        }
      }

      string += currentChar;

      if (currentIndex >= sourceCode.length - 1) {
        throw Error(currentLine, lineIndex, 'Missing closing quotation for String.');
      }

      advance();
    }

    advance();

    return Token(
      lineNumber: startLine,
      lineIndex: start,
      type: TokenTypes.string,
      value: string,
    );
  }

  Token getNextToken() {
    TokenTypes type = TokenTypes.eof;
    final preLineNumber = currentLine;
    final preLineIndex = lineIndex;
    String value = currentChar;

    while (currentChar.contains(RegExp('[\n ]'))) {
      lineIndex++;

      if (currentChar == '\n') {
        currentLine++;
        lineIndex = 0;
      }

      if (currentIndex < sourceCode.length) {
        currentChar = sourceCode[currentIndex];
      } else {
        break;
      }
      currentIndex++;

      if (currentIndex < sourceCode.length) {
        currentChar = sourceCode[currentIndex];
      }
    }

    if (currentIndex < sourceCode.length) {
      currentChar = sourceCode[currentIndex];

      if (currentChar.contains(RegExp('[A-Za-z_]'))) {
        return collectIdentifier();
      }

      if (currentChar.contains(RegExp('[\'"]'))) {
        return collectString();
      }

      if (currentChar.contains(RegExp('[0-9]'))) {
        return collectNumber();
      }

      switch (currentChar) {
        case '(':
          type = TokenTypes.leftParen;
          advance();
        case ')':
          type = TokenTypes.rightParen;
          advance();
        case '{':
          type = TokenTypes.leftBrace;
          advance();
        case '}':
          type = TokenTypes.rightBrace;
          advance();
        case '[':
          type = TokenTypes.leftBracket;
          advance();
        case ']':
          type = TokenTypes.rightBracket;
          advance();
        case ',':
          type = TokenTypes.comma;
          advance();
        case '.':
          type = TokenTypes.dot;
          advance();
        case ';':
          type = TokenTypes.semicolon;
          advance();
        case '=':
          type = TokenTypes.equal;
          advance();
          if (currentChar == '=') {
            type = TokenTypes.equalEqual;
            value += currentChar;
            advance();
          }
        case '+':
          type = TokenTypes.plus;
          advance();
        case '-':
          type = TokenTypes.minus;
          advance();
        case '*':
          type = TokenTypes.multiplication;
          advance();
        case '/':
          type = TokenTypes.division;
          advance();
        case '>':
          type = TokenTypes.greaterThan;
          advance();
          if (currentChar == '=') {
            type = TokenTypes.greaterThanEqualTo;
            value += currentChar;
            advance();
          }
        case '<':
          type = TokenTypes.lessThan;
          advance();
          if (currentChar == '=') {
            type = TokenTypes.lessThanEqualTo;
            value += currentChar;
            advance();
          }
        case '!':
          type = TokenTypes.not;
          advance();
          if (currentChar == '=') {
            type = TokenTypes.notEqual;
            value += currentChar;
            advance();
          }
        case '?':
          type = TokenTypes.questionMark;
          advance();
        case ':':
          type = TokenTypes.colon;
          advance();
        case '&':
          advance();
          if (currentChar == '&') {
            type = TokenTypes.and;
            value += currentChar;
            advance();
          } else {
            throw Error(currentLine, lineIndex, 'Incorrect character');
          }
        case '|':
          advance();
          if (currentChar == '|') {
            type = TokenTypes.and;
            value += currentChar;
            advance();
          } else {
            throw Error(currentLine, lineIndex, 'Incorrect character');
          }
      }
    }

    return Token(
      lineNumber: preLineNumber,
      type: type,
      value: value,
      lineIndex: preLineIndex,
    );
  }
}
