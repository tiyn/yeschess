import einheit
import algorithm

import ./chess

testSuite GameTest of TestSuite:

  var
    game: Game

  method setup() =
    self.game = initGame()

  ## Tests for isInCheck()
  method testIsInCheckFalse() =
    self.setup()
    self.game.checkedMove(notationToMove("e2e4", Color.White))
    self.game.checkedMove(notationToMove("e7e5", Color.Black))
    self.game.checkedMove(notationToMove("d2d3", Color.White))
    self.game.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(not self.game.isInCheck(Color.White))
    self.check(not self.game.isInCheck(Color.White))

  method testIsInCheckTrueWhite() =
    self.setup()
    self.game.checkedMove(notationToMove("f2f4", Color.White))
    self.game.checkedMove(notationToMove("e7e5", Color.Black))
    self.game.checkedMove(notationToMove("e2e3", Color.White))
    self.game.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(self.game.isInCheck(Color.White))

  method testIsInCheckTrueBlack() =
    self.setup()
    self.game.checkedMove(notationToMove("e2e4", Color.White))
    self.game.checkedMove(notationToMove("f7f6", Color.Black))
    self.game.checkedMove(notationToMove("d2d4", Color.White))
    self.game.checkedMove(notationToMove("g7g5", Color.Black))
    self.game.checkedMove(notationToMove("d1h5", Color.White))
    self.check(self.game.isInCheck(Color.Black))

  ## Tests for isCheckmate()
  method testIsCheckmateFalseWhite() =
    self.setup()
    self.game.checkedMove(notationToMove("f2f4", Color.White))
    self.game.checkedMove(notationToMove("e7e5", Color.Black))
    self.game.checkedMove(notationToMove("e2e3", Color.White))
    self.game.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(not self.game.isCheckmate(Color.White))

  method testIsCheckmateFalseBlack() =
    self.setup()
    self.game.checkedMove(notationToMove("f2f4", Color.White))
    self.game.checkedMove(notationToMove("e7e5", Color.Black))
    self.game.checkedMove(notationToMove("e2e3", Color.White))
    self.game.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(not self.game.isCheckmate(Color.Black))

  method testIsCheckmateTrueWhite() =
    self.setup()
    self.game.checkedMove(notationToMove("f2f3", Color.White))
    self.game.checkedMove(notationToMove("e7e6", Color.Black))
    self.game.checkedMove(notationToMove("g2g4", Color.White))
    self.game.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(self.game.isCheckmate(Color.White))

  method testIsCheckmateTrueBlack() =
    self.setup()
    self.game.checkedMove(notationToMove("e2e4", Color.White))
    self.game.checkedMove(notationToMove("g7g5", Color.Black))
    self.game.checkedMove(notationToMove("d2d4", Color.White))
    self.game.checkedMove(notationToMove("f7f6", Color.Black))
    self.game.checkedMove(notationToMove("d1h5", Color.White))
    self.check(self.game.isCheckmate(Color.Black))

  ## Tests for isStalemate()
  method testIsStalemateFalse() =
    self.setup()
    self.game.checkedMove(notationToMove("f2f3", Color.White))
    self.game.checkedMove(notationToMove("e7e6", Color.Black))
    self.game.checkedMove(notationToMove("g2g4", Color.White))
    self.game.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(not self.game.isStalemate(Color.White))
    self.check(not self.game.isStalemate(Color.Black))

  method testIsStalemateTrueWhite() =
    self.game = initGame([
      0, 0, 0, 0, BRook, BQueen, BRook, BKnight,
      0, BPawn, 0, 0, BPawn, BPawn, BBishop, WKing,
      0, BPawn, 0, BPawn, 0, BPawn, 0, BKnight,
      0, 0, 0, 0, 0, 0, BPawn, 0,
      0, 0, BBishop, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, BPawn, BKing, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.White)
    self.check(self.game.isStalemate(Color.White))

  method testIsStalemateTrueBlack() =
    self.game = initGame([
      0, 0, 0, 0, WRook, WQueen, WRook, WKnight,
      0, WPawn, 0, 0, WPawn, WPawn, WBishop, BKing,
      0, WPawn, 0, WPawn, 0, WPawn, 0, WKnight,
      0, 0, 0, 0, 0, 0, WPawn, 0,
      0, 0, WBishop, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, WPawn, WKing, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.game.isStalemate(Color.Black))

  method testIsStalemateInsufficientMaterialTrue() =
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.game.isStalemate(Color.Black))
    self.check(self.game.isStalemate(Color.White))
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, WKnight,
      0, 0, WKnight, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.game.isStalemate(Color.Black))
    self.check(self.game.isStalemate(Color.White))
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BKnight,
      0, 0, BKnight, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.game.isStalemate(Color.Black))
    self.check(self.game.isStalemate(Color.White))
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BKnight,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.game.isStalemate(Color.Black))
    self.check(self.game.isStalemate(Color.White))
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, WKnight,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.game.isStalemate(Color.Black))
    self.check(self.game.isStalemate(Color.White))
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BBishop,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.game.isStalemate(Color.Black))
    self.check(self.game.isStalemate(Color.White))
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, WBishop,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.game.isStalemate(Color.Black))
    self.check(self.game.isStalemate(Color.White))

  method testIsStalemateInsufficientMaterialFalse() =
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.game.isStalemate(Color.Black))
    self.check(not self.game.isStalemate(Color.White))
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.game.isStalemate(Color.Black))
    self.check(not self.game.isStalemate(Color.White))
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.game.isStalemate(Color.Black))
    self.check(not self.game.isStalemate(Color.White))
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, WRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.game.isStalemate(Color.Black))
    self.check(not self.game.isStalemate(Color.White))
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, WBishop, 0, 0, 0, 0, 0, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.game.isStalemate(Color.Black))
    self.check(not self.game.isStalemate(Color.White))
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, BBishop, 0, 0, 0, 0, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.game.isStalemate(Color.Black))
    self.check(not self.game.isStalemate(Color.White))

  ## Tests for Pawn moves
  method testCheckedMovePawnSingleTrue() =
    self.setup()
    var test: bool
    for file in "abcdefgh":
      test = self.game.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
      self.check(test)
      test = self.game.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
      self.check(test)
      test = self.game.checkedMove(notationToMove($file & "3" & $file & "4", Color.White))
      self.check(test)
      test = self.game.checkedMove(notationToMove($file & "6" & $file & "5", Color.Black))
      self.check(test)

  method testCheckedMovePawnSingleFalseIntoEnemyPiece() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.game = pos
    for file in "abcdefgh":
      test = self.game.checkedMove(notationToMove($file & "4" & $file & "5", Color.White))
      self.check(not test)
      test = self.game.checkedMove(notationToMove($file & "5" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnSingleFalseIntoOwnPiece() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.game = pos
    for file in "abcdefgh":
      test = self.game.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
      self.check(not test)
      test = self.game.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleTrue() =
    self.setup()
    var test: bool
    for file in "abcdefgh":
      test = self.game.checkedMove(notationToMove($file & "2" & $file & "4", Color.White))
      self.check(test)
      test = self.game.checkedMove(notationToMove($file & "7" & $file & "5", Color.Black))
      self.check(test)

  method testCheckedMovePawnDoubleFalseAlreadyMoved() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.game = pos
    for file in "abcdefgh":
      test = self.game.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.game.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseThroughEnemyPiece() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.game = pos
    for file in "abcdefgh":
      test = self.game.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.game.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseThroughOwnPiece() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.game = pos
    for file in "abcdefgh":
      test = self.game.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.game.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseIntoEnemyPiece() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.game = pos
    for file in "abcdefgh":
      test = self.game.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.game.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseIntoOwnPiece() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.game = pos
    for file in "abcdefgh":
      test = self.game.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.game.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnCaptureTrueWhite() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    var str: string
    str = "abcdefgh"
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "5", Color.White))
        self.check(test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "5", Color.White))
        self.check(test)

  method testCheckedMovePawnCaptureTrueBlack() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.Black)
    var str: string
    str = "abcdefgh"
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "4", Color.Black))
        self.check(test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "4", Color.Black))
        self.check(test)

  method testCheckedMovePawnCaptureFalseWhite() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    var str: string
    str = "abcdefgh"
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "5", Color.White))
        self.check(not test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "5", Color.White))
        self.check(not test)

  method testCheckedMovePawnCaptureFalseBlack() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.Black)
    var str: string
    str = "abcdefgh"
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "4", Color.Black))
        self.check(not test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "4", Color.Black))
        self.check(not test)

  method testCheckedMovePawnEnPassantTrueWhite() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    var str: string
    str = "abcdefgh"
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "2" & $file & "4", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "4" & $file & "5", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($str[ind+1] & "7" & $str[
            ind+1] & "5", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "6", Color.White))
        self.check(test)
        test = (0 == self.game.board.getField(fieldToInd($str[ind+1] & "5")))
        self.check(test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "2" & $file & "4", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "4" & $file & "5", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($str[ind+1] & "7" & $str[
            ind+1] & "5", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "6", Color.White))
        self.check(test)
        test = (0 == self.game.board.getField(fieldToInd($str[ind+1] & "5")))
        self.check(test)

  method testCheckedMovePawnEnPassantTrueBlack() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.Black)
    var str: string
    str = "abcdefgh"
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "7" & $file & "5", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "5" & $file & "4", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($str[ind+1] & "2" & $str[
            ind+1] & "4", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "3", Color.Black))
        self.check(test)
        test = (0 == self.game.board.getField(fieldToInd($str[ind+1] & "4")))
        self.check(test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "7" & $file & "5", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "5" & $file & "4", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($str[ind+1] & "2" & $str[
            ind+1] & "4", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "3", Color.Black))
        self.check(test)
        test = (0 == self.game.board.getField(fieldToInd($str[ind+1] & "4")))
        self.check(test)

  method testCheckedMovePawnEnPassantFalseWhite() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    var str: string
    str = "abcdefgh"
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "2" & $file & "4", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($str[ind+1] & "7" & $str[
            ind+1] & "5", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "4" & $file & "5", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "6", Color.White))
        self.check(not test)
        test = (0 == self.game.board.getField(fieldToInd($str[ind+1] & "5")))
        self.check(not test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "2" & $file & "4", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($str[ind+1] & "7" & $str[
            ind+1] & "5", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "4" & $file & "5", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "6", Color.White))
        self.check(not test)
        test = (0 == self.game.board.getField(fieldToInd($str[ind+1] & "5")))
        self.check(not test)

  method testCheckedMovePawnEnPassantFalseBlack() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.Black)
    var str: string
    str = "abcdefgh"
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "7" & $file & "5", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($str[ind+1] & "2" & $str[
            ind+1] & "4", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "5" & $file & "4", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "3", Color.Black))
        self.check(not test)
        test = (0 == self.game.board.getField(fieldToInd($str[ind+1] & "4")))
        self.check(not test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.game = pos
        test = self.game.checkedMove(notationToMove($file & "7" & $file & "5", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($str[ind+1] & "2" & $str[
            ind+1] & "4", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "5" & $file & "4", Color.Black))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
        self.check(test)
        test = self.game.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "3", Color.Black))
        self.check(not test)
        test = (0 == self.game.board.getField(fieldToInd($str[ind+1] & "4")))
        self.check(not test)

  ## Tests for King moves
  method testCheckedMoveKingCastleTrueWhite() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.game = pos
    test = self.game.checkedMove(notationToMove("e1c1", Color.White))
    self.check(test)
    self.game = pos
    self.game.checkedMove(notationToMove("e1g1", Color.White))
    self.check(test)

  method testCheckedMoveKingCastleTrueBlack() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.Black)
    self.game = pos
    test = self.game.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(test)
    self.game = pos
    test = self.game.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(test)

  method testCheckedMoveKingCastleFalseAlreadyMovedKing() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, 0, WKing, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, 0, BKing, 0, 0, BRook
    ], Color.White)
    self.game.checkedMove(notationToMove("d1e1", Color.White))
    self.game.checkedMove(notationToMove("d8e8", Color.White))
    self.game = pos
    test = self.game.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.game.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseAlreadyMovedRook() =
    var test: bool
    let pos = initGame([
      0, WRook, 0, WKing, 0, 0, WRook, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, BRook, 0, BKing, 0, 0, BRook, 0
    ], Color.White)
    self.game = pos
    self.game.checkedMove(notationToMove("b1a1", Color.White))
    self.game.checkedMove(notationToMove("b8a8", Color.Black))
    self.game.checkedMove(notationToMove("g1h1", Color.White))
    self.game.checkedMove(notationToMove("g8h8", Color.Black))
    test = self.game.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.game.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseThroughCheck() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, BRook, WPawn, BRook, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, WRook, BPawn, WRook, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.game = pos
    test = self.game.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.game.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseIntoCheck() =
    var test: bool
    let pos = initGame([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, BRook, WPawn, WPawn, WPawn, BRook, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, WRook, BPawn, BPawn, BPawn, WRook, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.game = pos
    test = self.game.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.game.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseThroughOwnPiece() =
    var test: bool
    let pos = initGame([
      WRook, 0, WBishop, WKing, WBishop, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, BBishop, BKing, BBishop, 0, 0, BRook
    ], Color.White)
    self.game = pos
    test = self.game.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.game.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseThroughEnemyPiece() =
    var test: bool
    let pos = initGame([
      WRook, 0, BBishop, WKing, BBishop, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, WBishop, BKing, WBishop, 0, 0, BRook
    ], Color.White)
    self.game = pos
    test = self.game.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.game.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseIntoOwnPiece() =
    var test: bool
    let pos = initGame([
      WRook, WBishop, 0, WKing, 0, WBishop, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, BBishop, 0, BKing, 0, BBishop, 0, BRook
    ], Color.White)
    self.game = pos
    test = self.game.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.game.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseIntoEnemyPiece() =
    var test: bool
    let pos = initGame([
      WRook, BBishop, 0, WKing, 0, BBishop, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, WBishop, 0, BKing, 0, WBishop, 0, BRook
    ], Color.White)
    self.game = pos
    test = self.game.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.game.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.game.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingWhite() =
    var test: bool
    let pos = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, WEnPassant, 0, 0, 0,
      0, 0, BPawn, WKing, WPawn, 0, 0, 0,
      0, 0, BEnPassant, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
    ], Color.White)
    let start = "e5"
    let legalMoves = ["f4", "d4", "f5", "f6", "e6", "d6"]
    let str = "abcdefgh"
    var move: string
    for cha in str:
      for num in 1..8:
        self.game = pos
        move = $cha & $num
        test = self.game.checkedMove(notationToMove(start & move, Color.White))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  method testCheckedMoveKingBlack() =
    var test: bool
    let pos = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, BEnPassant, 0, 0, 0,
      0, 0, WPawn, BKing, BPawn, 0, 0, 0,
      0, 0, WEnPassant, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
    ], Color.Black)
    let start = "e5"
    let legalMoves = ["f4", "d4", "f5", "f6", "e4", "d6"]
    let str = "abcdefgh"
    var move: string
    for cha in str:
      for num in 1..8:
        self.game = pos
        move = $cha & $num
        test = self.game.checkedMove(notationToMove(start & move, Color.Black))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  ## Tests for Bishop moves
  method testCheckedMoveBishopWhite() =
    var test: bool
    let pos = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, BEnPassant, 0, WPawn, 0, 0,
      0, 0, 0, 0, WBishop, 0, 0, 0,
      0, 0, 0, BPawn, 0, WEnPassant, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
    ], Color.White)
    let start = "d5"
    let legalMoves = ["e4", "f3", "g2", "h1", "c6", "b7", "a8", "e6"]
    let str = "abcdefgh"
    var move: string
    for cha in str:
      for num in 1..8:
        self.game = pos
        move = $cha & $num
        test = self.game.checkedMove(notationToMove(start & move, Color.White))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  method testCheckedMoveBishopBlack() =
    var test: bool
    let pos = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WEnPassant, 0, BPawn, 0, 0,
      0, 0, 0, 0, BBishop, 0, 0, 0,
      0, 0, 0, WPawn, 0, BEnPassant, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
    ], Color.Black)
    let start = "d5"
    let legalMoves = ["e4", "f3", "g2", "h1", "c6", "b7", "a8", "e6"]
    let str = "abcdefgh"
    var move: string
    for cha in str:
      for num in 1..8:
        self.game = pos
        move = $cha & $num
        test = self.game.checkedMove(notationToMove(start & move, Color.Black))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  ## Tests for Knight moves
  method testCheckedMoveKnightWhite() =
    var test: bool
    let pos = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WEnPassant, 0, WPawn, 0, 0,
      0, 0, BEnPassant, 0, 0, 0, 0, 0,
      0, 0, 0, 0, WKnight, 0, 0, 0,
      0, 0, BPawn, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
    ], Color.White)
    let start = "d5"
    let legalMoves = ["f6", "f4", "e3", "b4", "b6", "c7", "e7"]
    let str = "abcdefgh"
    var move: string
    for cha in str:
      for num in 1..8:
        self.game = pos
        move = $cha & $num
        test = self.game.checkedMove(notationToMove(start & move, Color.White))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  method testCheckedMoveKnightBlack() =
    var test: bool
    let pos = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, BEnPassant, 0, BPawn, 0, 0,
      0, 0, WEnPassant, 0, 0, 0, 0, 0,
      0, 0, 0, 0, BKnight, 0, 0, 0,
      0, 0, WPawn, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
    ], Color.Black)
    let start = "d5"
    let legalMoves = ["f6", "f4", "e3", "b4", "b6", "c7", "e7"]
    let str = "abcdefgh"
    var move: string
    for cha in str:
      for num in 1..8:
        self.game = pos
        move = $cha & $num
        test = self.game.checkedMove(notationToMove(start & move, Color.Black))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  ## Tests for Rook moves
  method testCheckedMoveRookWhite() =
    var test: bool
    let pos = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, WPawn, 0, 0, 0,
      0, 0, 0, BPawn, WRook, WEnPassant, 0, 0,
      0, 0, 0, 0, BEnPassant, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
    ], Color.White)
    let start = "d5"
    let legalMoves = ["e5", "d6", "d7", "d8", "c5", "b5", "a5"]
    let str = "abcdefgh"
    var move: string
    for cha in str:
      for num in 1..8:
        self.game = pos
        move = $cha & $num
        test = self.game.checkedMove(notationToMove(start & move, Color.White))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  method testCheckedMoveRookBlack() =
    var test: bool
    let pos = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, BPawn, 0, 0, 0,
      0, 0, 0, WPawn, BRook, BEnPassant, 0, 0,
      0, 0, 0, 0, WEnPassant, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
    ], Color.Black)
    let start = "d5"
    let legalMoves = ["e5", "d6", "d7", "d8", "c5", "b5", "a5"]
    let str = "abcdefgh"
    var move: string
    for cha in str:
      for num in 1..8:
        self.game = pos
        move = $cha & $num
        test = self.game.checkedMove(notationToMove(start & move, Color.Black))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  ## Tests for Queen moves
  method testCheckedMoveQueenWhite() =
    var test: bool
    let pos = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, WPawn, 0, 0, 0,
      0, 0, 0, BPawn, WQueen, WEnPassant, 0, 0,
      0, 0, 0, 0, BEnPassant, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
    ], Color.White)
    let start = "d5"
    let legalMoves = ["e5", "d6", "d7", "d8", "c5", "b5", "a5", "h1", "g2",
        "f3", "e4", "c4", "b3", "a2", "g8", "f7", "e6", "c6", "b7", "a8"]
    let str = "abcdefgh"
    var move: string
    for cha in str:
      for num in 1..8:
        self.game = pos
        move = $cha & $num
        test = self.game.checkedMove(notationToMove(start & move, Color.White))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  method testCheckedMoveQueenBlack() =
    var test: bool
    let pos = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, BPawn, 0, 0, 0,
      0, 0, 0, WPawn, BQueen, BEnPassant, 0, 0,
      0, 0, 0, 0, WEnPassant, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
    ], Color.Black)
    let start = "d5"
    let legalMoves = ["e5", "d6", "d7", "d8", "c5", "b5", "a5", "h1", "g2",
        "f3", "e4", "c4", "b3", "a2", "g8", "f7", "e6", "c6", "b7", "a8"]
    let str = "abcdefgh"
    var move: string
    for cha in str:
      for num in 1..8:
        self.game = pos
        move = $cha & $num
        test = self.game.checkedMove(notationToMove(start & move, Color.Black))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

when isMainModule:
  einheit.runTests()
