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
  late String currentChar = sourceCode.isEmpty ? '' : sourceCode[currentIndex];

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
    return 'end';
  }

  Token collectIdentifier() {
    final start = lineIndex;

    String id = currentChar;
    advance();

    if (!currentChar.contains(RegExp('[\n ]'))) {
      if (currentIndex < sourceCode.length) {
        while (currentChar.contains(RegExp('[A-Za-z_0-9]'))) {
          id += currentChar;

          advance();

          if (currentChar.contains(RegExp('[\n ]')) ||
              currentIndex >= sourceCode.length) {
            switch (id) {
              case 'true':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.trueToken,
                  value: id,
                );
              case 'false':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.falseToken,
                  value: id,
                );
              case 'class':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.classToken,
                  value: id,
                );
              case 'fun':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.function,
                  value: id,
                );
              case 'if':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.ifToken,
                  value: id,
                );
              case 'for':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.forToken,
                  value: id,
                );
              case 'while':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.whileToken,
                  value: id,
                );
              case 'else':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.elseToken,
                  value: id,
                );
              case 'null':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.nullToken,
                  value: id,
                );
              case 'return':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.returnToken,
                  value: id,
                );
              case 'var':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.varToken,
                  value: id,
                );
              case 'this':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.thisToken,
                  value: id,
                );
              case 'super':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.superToken,
                  value: id,
                );
              case 'print':
                return Token(
                  lineNumber: currentLine,
                  lineIndex: start,
                  type: TokenTypes.printToken,
                  value: id,
                );
            }
          }
          if (currentIndex >= sourceCode.length) {
            currentIndex++;
            break;
          }
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

    String number = currentChar;
    advance();

    if (!currentChar.contains(RegExp('[\n ]'))) {
      if (currentIndex < sourceCode.length) {
        if (number == '0') {
          if (currentChar == 'b' && peak().contains(RegExp('[01]'))) {
            number = '';
            advance();

            while (currentChar.contains(RegExp('[01]'))) {
              number += currentChar;

              if (currentIndex >= sourceCode.length - 1) {
                currentIndex++;
                break;
              }

              advance();
            }

            number = '${int.parse(number, radix: 2)}';

            return Token(
              lineNumber: currentLine,
              lineIndex: start,
              type: TokenTypes.number,
              value: number,
            );
          } else if (currentChar == 'x' &&
              currentIndex < sourceCode.length - 1 &&
              peak().contains(RegExp('[0-9A-Fa-f]'))) {
            number = '';
            advance();

            while (currentChar.contains(RegExp('[0-9A-Fa-f]'))) {
              number += currentChar;

              if (currentIndex >= sourceCode.length - 1) {
                currentIndex++;
                break;
              }

              advance();
            }

            number = '${int.parse(number, radix: 16)}';

            return Token(
              lineNumber: currentLine,
              lineIndex: start,
              type: TokenTypes.number,
              value: number,
            );
          }

          while (currentChar == '0') {
            advance();
          }
        }

        if (currentChar == '.') {
          if (peak().contains(RegExp('[0-9]'))) {
            number += currentChar;
            advance();
          }
        }

        while (currentChar.contains(RegExp('[0-9]'))) {
          number += currentChar;

          if (currentIndex >= sourceCode.length - 1) {
            currentIndex++;
            break;
          }

          advance();

          if (currentChar == '.' && !number.contains(RegExp('[.]'))) {
            if (peak().contains(RegExp('[0-9]'))) {
              number += currentChar;
              advance();
            }
          }
        }
      }
    }

    if (number.length > 1 &&
        number[0] == '0' &&
        number[1].contains(RegExp('[1-9]'))) {
      number = number.replaceFirst(RegExp('0'), '');
    }

    if (number.length > 3 && number.contains(RegExp('[.]'))) {
      while (number.endsWith('0')) {
        number = number.substring(0, number.length - 1);
      }
    }

    return Token(
      lineNumber: currentLine,
      lineIndex: start,
      type: TokenTypes.number,
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
        throw Error(
            currentLine, lineIndex, 'Missing closing quotation for String.');
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

    while (true) {
      if (currentChar.contains(RegExp('[/ \n]'))) {
        if (currentChar == '/') {
          if (peak() == '/') {
            while (true) {
              advance();

              if (currentChar == '\n') {
                advance();
                currentLine++;
                lineIndex = 0;
                break;
              }

              if (currentIndex == sourceCode.length - 1) {
                advance();
                break;
              }
            }
          } else if (peak() == '*') {
            advance();
            advance();

            while (true) {
              if (currentChar == '\n') {
                advance();
                currentLine++;
                lineIndex = 0;
              }

              if (currentIndex < sourceCode.length - 1) {
                if (currentChar == '*' && peak() == '/') {
                  advance();
                  advance();
                  break;
                }

                if (currentIndex == sourceCode.length - 2 &&
                    !sourceCode.endsWith('*/')) {
                  throw Error(
                      currentLine, lineIndex, "Missing */ to end the comment");
                }

                advance();
              }
            }
          } else {
            break;
          }
        }

        while (currentChar.contains(RegExp('[\n ]'))) {
          if (currentChar == '\n') {
            advance();
            currentLine++;
            lineIndex = 0;
          } else if (currentChar == ' ') {
            advance();
          }
        }
      } else {
        break;
      }
    }

    String value = currentChar;
    final preLineNumber = currentLine;
    final preLineIndex = lineIndex;

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
            type = TokenTypes.or;
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
