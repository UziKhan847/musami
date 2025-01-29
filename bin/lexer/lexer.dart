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

  Token collectIdentifier() {
    final start = lineIndex;

    String id = currentChar;
    advance();

    if (!currentChar.contains(RegExp('[\n ]'))) {
      if (currentIndex < sourceCode.length) {
        while (currentChar.contains(RegExp('[A-Za-z_0-9]'))) {
          id += currentChar;

          if (currentIndex >= sourceCode.length - 1) {
            currentIndex++;
            break;
          }

          advance();

          if (currentChar.contains(RegExp('[\n ]'))) {
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
                  type: TokenTypes.identifiers,
                  value: id,
                );
              case 'function':
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

    if (!currentChar.contains(RegExp('[\n )}],;:=+-*/><]'))) {
      if ((number != '0' && !currentChar.contains(RegExp('[0-9.]'))) ||
          (number == '0' && !currentChar.contains(RegExp('[0-9.bx]')))) {
        throw Error(currentLine, lineIndex, 'Invalid number.');
      }

      if (currentIndex < sourceCode.length) {
        if (number == '0') {
          // while (currentChar == '0') {
          //   advance();
          // }

          if (currentChar == 'b') {
            number = '';
            advance();

            if (!currentChar.contains(RegExp('[01]'))) {
              throw Error(currentLine, lineIndex, "Invalid binary number.");
            }

            while (currentChar.contains(RegExp('[01]'))) {
              number += currentChar;

              if (currentIndex >= sourceCode.length - 1) {
                currentIndex++;
                break;
              }

              advance();

              if (!currentChar.contains(RegExp('[01\n )}],;:=+-*/><]'))) {
                throw Error(currentLine, lineIndex, "Invalid binary number.");
              }
            }

            number = '${int.parse(number, radix: 2)}';

            return Token(
              lineNumber: currentLine,
              lineIndex: start,
              type: TokenTypes.number,
              value: number,
            );
          } else if (currentChar == 'x') {
            number = '';
            advance();

            if (!currentChar.contains(RegExp('[0-9A-Fa-f]'))) {
              throw Error(
                  currentLine, lineIndex, "Invalid hexadecimal number.");
            }

            while (currentChar.contains(RegExp('[0-9A-Fa-f]'))) {
              number += currentChar;

              if (currentIndex >= sourceCode.length - 1) {
                currentIndex++;
                break;
              }

              advance();

              if (!currentChar
                  .contains(RegExp('[0-9A-Fa-f\n )}],;:=+-*/><]'))) {
                throw Error(
                    currentLine, lineIndex, "Invalid hexadecimal number.");
              }
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
          number += currentChar;
          advance();
        }

        //Error check

        while (currentChar.contains(RegExp('[0-9]'))) {
          number += currentChar;

          if (currentIndex >= sourceCode.length - 1) {
            currentIndex++;
            break;
          }

          advance();

          if (currentChar == '.') {
            if (number.contains(RegExp('[.]'))) {
              throw Error(currentLine, lineIndex,
                  'Invalid number, too many decimal points.');
            } else {
              number += currentChar;
              advance();

              //Error check???
            }
          }

          //Error check
        }
      }
    }

    if (number[0] == '0' && number[1].contains(RegExp('[1-9]'))) {
      number = number.replaceFirst(RegExp('0'), '');
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
    final preLineNumber = currentLine;
    final preLineIndex = lineIndex;

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

    String value = currentChar;

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
