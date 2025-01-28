enum TokenTypes {
  // Single char tokens
  leftParen,
  rightParen,
  leftBrace,
  rightBrace,
  rightBracket,
  leftBracket,
  comma,
  dot,
  semicolon,
  equal,
  plus,
  minus,
  multiplication,
  division,
  greaterThan,
  lessThan,
  not,
  questionMark,
  colon,

  // Multi char tokens
  equalEqual,
  greaterThanEqualTo,
  lessThanEqualTo,
  notEqual,
  and,
  or,

  // Literal
  identifiers,
  string,
  number,
  trueToken,
  falseToken,

  // Keywords
  classToken,
  function, //What word is used for function?
  ifToken, //if comes, then it is if token, i dont have to care about the bracktes after it?
  forToken,
  whileToken,
  elseToken,
  nullToken,
  returnToken,
  varToken,
  thisToken,
  superToken,
  printToken,
  eof,
}

/*
  var a = 10;
  10.0
  "asdf".length
  true

  fun a() {}

  class A {}
*/

class Token {
  Token({
    required this.lineNumber,
    required this.type,
    required this.value,
    required this.lineIndex,
  });

  final TokenTypes type;
  final dynamic value;
  final int lineNumber;
  final int lineIndex;

  @override
  String toString() =>
      '----------\nTokenType: $type,\nValue: $value,\nLine Number: $lineNumber,\nLine Index: $lineIndex';
}
