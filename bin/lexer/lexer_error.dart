class LexerError extends Error {
  LexerError(this.currentLine, this.lineIndex, this.message);

  String message;
  int currentLine;
  int lineIndex;

  @override
  String toString() => "Error on Line $currentLine, Index $lineIndex. $message";
}
