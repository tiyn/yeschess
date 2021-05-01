import einheit
import algorithm

import ./chess.nim

testSuite ChessTest of TestSuite:

  var
    chess: Chess

  method setup() =
    self.chess = initChess()

  ## Tests for isInCheck()
  method testIsInCheckFalse() =
    self.setup()
    self.chess.checkedMove(notationToMove("e2e4", Color.White))
    self.chess.checkedMove(notationToMove("e7e5", Color.Black))
    self.chess.checkedMove(notationToMove("d2d3", Color.White))
    self.chess.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(not self.chess.isInCheck(Color.White))
    self.check(not self.chess.isInCheck(Color.White))

  method testIsInCheckTrueWhite() =
    self.setup()
    self.chess.checkedMove(notationToMove("f2f4", Color.White))
    self.chess.checkedMove(notationToMove("e7e5", Color.Black))
    self.chess.checkedMove(notationToMove("e2e3", Color.White))
    self.chess.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(self.chess.isInCheck(Color.White))

  method testIsInCheckTrueBlack() =
    self.setup()
    self.chess.checkedMove(notationToMove("e2e4", Color.White))
    self.chess.checkedMove(notationToMove("f7f6", Color.Black))
    self.chess.checkedMove(notationToMove("d2d4", Color.White))
    self.chess.checkedMove(notationToMove("g7g5", Color.Black))
    self.chess.checkedMove(notationToMove("d1h5", Color.White))
    self.check(self.chess.isInCheck(Color.Black))

  ## Tests for isCheckmate()
  method testIsCheckmateFalseWhite() =
    self.setup()
    self.chess.checkedMove(notationToMove("f2f4", Color.White))
    self.chess.checkedMove(notationToMove("e7e5", Color.Black))
    self.chess.checkedMove(notationToMove("e2e3", Color.White))
    self.chess.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(not self.chess.isCheckmate(Color.White))

  method testIsCheckmateFalseBlack() =
    self.setup()
    self.chess.checkedMove(notationToMove("f2f4", Color.White))
    self.chess.checkedMove(notationToMove("e7e5", Color.Black))
    self.chess.checkedMove(notationToMove("e2e3", Color.White))
    self.chess.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(not self.chess.isCheckmate(Color.Black))

  method testIsCheckmateTrueWhite() =
    self.setup()
    self.chess.checkedMove(notationToMove("f2f3", Color.White))
    self.chess.checkedMove(notationToMove("e7e6", Color.Black))
    self.chess.checkedMove(notationToMove("g2g4", Color.White))
    self.chess.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(self.chess.isCheckmate(Color.White))

  method testIsCheckmateTrueBlack() =
    self.setup()
    self.chess.checkedMove(notationToMove("e2e4", Color.White))
    self.chess.checkedMove(notationToMove("g7g5", Color.Black))
    self.chess.checkedMove(notationToMove("d2d4", Color.White))
    self.chess.checkedMove(notationToMove("f7f6", Color.Black))
    self.chess.checkedMove(notationToMove("d1h5", Color.White))
    self.check(self.chess.isCheckmate(Color.Black))

  ## Tests for isStalemate()
  method testIsStalemateFalse() =
    self.setup()
    self.chess.checkedMove(notationToMove("f2f3", Color.White))
    self.chess.checkedMove(notationToMove("e7e6", Color.Black))
    self.chess.checkedMove(notationToMove("g2g4", Color.White))
    self.chess.checkedMove(notationToMove("d8h4", Color.Black))
    self.check(not self.chess.isStalemate(Color.White))
    self.check(not self.chess.isStalemate(Color.Black))

  method testIsStalemateTrueWhite() =
    self.chess = initChess([
      0, 0, 0, 0, BRook, BQueen, BRook, BKnight,
      0, BPawn, 0, 0, BPawn, BPawn, BBishop, WKing,
      0, BPawn, 0, BPawn, 0, BPawn, 0, BKnight,
      0, 0, 0, 0, 0, 0, BPawn, 0,
      0, 0, BBishop, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, BPawn, BKing, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.White)
    self.check(self.chess.isStalemate(Color.White))

  method testIsStalemateTrueBlack() =
    self.chess = initChess([
      0, 0, 0, 0, WRook, WQueen, WRook, WKnight,
      0, WPawn, 0, 0, WPawn, WPawn, WBishop, BKing,
      0, WPawn, 0, WPawn, 0, WPawn, 0, WKnight,
      0, 0, 0, 0, 0, 0, WPawn, 0,
      0, 0, WBishop, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, WPawn, WKing, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.chess.isStalemate(Color.Black))

  method testIsStalemateInsufficientMaterialTrue() =
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, WKnight,
      0, 0, WKnight, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BKnight,
      0, 0, BKnight, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BKnight,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, WKnight,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BBishop,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, WBishop,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))

  method testIsStalemateInsufficientMaterialFalse() =
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.chess.isStalemate(Color.Black))
    self.check(not self.chess.isStalemate(Color.White))
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.chess.isStalemate(Color.Black))
    self.check(not self.chess.isStalemate(Color.White))
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.chess.isStalemate(Color.Black))
    self.check(not self.chess.isStalemate(Color.White))
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, WRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.chess.isStalemate(Color.Black))
    self.check(not self.chess.isStalemate(Color.White))
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, WBishop, 0, 0, 0, 0, 0, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.chess.isStalemate(Color.Black))
    self.check(not self.chess.isStalemate(Color.White))
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, BBishop, 0, 0, 0, 0, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    self.check(not self.chess.isStalemate(Color.Black))
    self.check(not self.chess.isStalemate(Color.White))

  ## Check isDrawClaimable
  method testIsDrawClaimableThreeFoldRepTrue() =
    self.setup()
    self.chess.checkedMove(notationToMove("g1f3", Color.White))
    self.chess.checkedMove(notationToMove("g8f6", Color.Black))
    self.chess.checkedMove(notationToMove("f3g1", Color.White))
    self.chess.checkedMove(notationToMove("f6g8", Color.Black))
    self.chess.checkedMove(notationToMove("g1f3", Color.White))
    self.chess.checkedMove(notationToMove("g8f6", Color.Black))
    self.chess.checkedMove(notationToMove("f3g1", Color.White))
    self.chess.checkedMove(notationToMove("f6g8", Color.Black))
    self.chess.checkedMove(notationToMove("g1f3", Color.White))
    self.check(self.chess.isDrawClaimable())

  method testIsDrawClaimableThreeFoldRepFalse() =
    self.setup()
    self.chess.checkedMove(notationToMove("g1f3", Color.White))
    self.chess.checkedMove(notationToMove("g8f6", Color.Black))
    self.chess.checkedMove(notationToMove("f3g1", Color.White))
    self.chess.checkedMove(notationToMove("f6g8", Color.Black))
    self.chess.checkedMove(notationToMove("g1f3", Color.White))
    self.chess.checkedMove(notationToMove("g8f6", Color.Black))
    self.chess.checkedMove(notationToMove("f3g1", Color.White))
    self.chess.checkedMove(notationToMove("f6g8", Color.Black))
    self.check(not self.chess.isDrawClaimable())

  method testIsDrawClaimableFiftyMoveRuleTrue() =
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      WBishop, 0, 0, 0, 0, 0, 0, 0,
      0, 0, WKing, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, WRook, 0,
      0, 0, 0, BKing, 0, 0, 0, 0
    ], Color.Black)
    self.chess.checkedMove(notationToMove("a2a5", Color.Black))
    self.chess.checkedMove(notationToMove("f5g6", Color.White))
    self.chess.checkedMove(notationToMove("a5e5", Color.Black))
    self.chess.checkedMove(notationToMove("h4f6", Color.White))
    self.chess.checkedMove(notationToMove("e5e2", Color.Black))
    self.chess.checkedMove(notationToMove("b7a7", Color.White))
    self.chess.checkedMove(notationToMove("e2e1", Color.Black))
    self.chess.checkedMove(notationToMove("g6f5", Color.White))
    self.chess.checkedMove(notationToMove("e1b1", Color.Black))
    self.chess.checkedMove(notationToMove("f6d4", Color.White))
    self.chess.checkedMove(notationToMove("e8d8", Color.Black))
    self.chess.checkedMove(notationToMove("f5e6", Color.White))
    self.chess.checkedMove(notationToMove("d8c8", Color.Black))
    self.chess.checkedMove(notationToMove("d4e5", Color.White))
    self.chess.checkedMove(notationToMove("b1c1", Color.Black))
    self.chess.checkedMove(notationToMove("a7f7", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("c2c1", Color.Black))
    self.chess.checkedMove(notationToMove("e6d5", Color.White))
    self.chess.checkedMove(notationToMove("c1a1", Color.Black))
    self.chess.checkedMove(notationToMove("f7h7", Color.White))
    self.chess.checkedMove(notationToMove("a1a2", Color.Black))
    self.chess.checkedMove(notationToMove("d6f4", Color.White))
    self.chess.checkedMove(notationToMove("a2a6", Color.Black))
    self.chess.checkedMove(notationToMove("f4e5", Color.White))
    self.chess.checkedMove(notationToMove("a6b6", Color.Black))
    self.chess.checkedMove(notationToMove("h7c7", Color.White))
    self.chess.checkedMove(notationToMove("c8d8", Color.Black))
    self.chess.checkedMove(notationToMove("c7a7", Color.White))
    self.chess.checkedMove(notationToMove("d8c8", Color.Black))
    self.chess.checkedMove(notationToMove("a7c7", Color.White))
    self.chess.checkedMove(notationToMove("c8d8", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("b6b1", Color.Black))
    self.chess.checkedMove(notationToMove("c7a7", Color.White))
    self.chess.checkedMove(notationToMove("b1e1", Color.Black))
    self.chess.checkedMove(notationToMove("d6e5", Color.White))
    self.chess.checkedMove(notationToMove("e1d1", Color.Black))
    self.chess.checkedMove(notationToMove("d5e6", Color.White))
    self.chess.checkedMove(notationToMove("d1c1", Color.Black))
    self.chess.checkedMove(notationToMove("a7b7", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("b7b3", Color.White))
    self.chess.checkedMove(notationToMove("c2c6", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("c6c1", Color.Black))
    self.chess.checkedMove(notationToMove("b3h3", Color.White))
    self.chess.checkedMove(notationToMove("d8c8", Color.Black))
    self.chess.checkedMove(notationToMove("h3h8", Color.White))
    self.chess.checkedMove(notationToMove("c8b7", Color.Black))
    self.chess.checkedMove(notationToMove("h8b8", Color.White))
    self.chess.checkedMove(notationToMove("b7a7", Color.Black))
    self.chess.checkedMove(notationToMove("b8b4", Color.White))
    self.chess.checkedMove(notationToMove("c1d1", Color.Black))
    self.chess.checkedMove(notationToMove("e6d7", Color.White))
    self.chess.checkedMove(notationToMove("d1c1", Color.Black))
    self.chess.checkedMove(notationToMove("d6c7", Color.White))
    self.chess.checkedMove(notationToMove("c1h1", Color.Black))
    self.chess.checkedMove(notationToMove("c7f4", Color.White))
    self.chess.checkedMove(notationToMove("h1h3", Color.Black))
    self.chess.checkedMove(notationToMove("f4e5", Color.White))
    self.chess.checkedMove(notationToMove("h3h1", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("h1c1", Color.Black))
    self.chess.checkedMove(notationToMove("d6f4", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("f4c7", Color.White))
    self.chess.checkedMove(notationToMove("c2c1", Color.Black))
    self.chess.checkedMove(notationToMove("b4b5", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("b5b6", Color.White))
    self.chess.checkedMove(notationToMove("c2g2", Color.Black))
    self.chess.checkedMove(notationToMove("b6b3", Color.White))
    self.chess.checkedMove(notationToMove("g2c2", Color.Black))
    self.chess.checkedMove(notationToMove("b3b1", Color.White))
    self.chess.checkedMove(notationToMove("c2c3", Color.Black))
    self.chess.checkedMove(notationToMove("c7e5", Color.White))
    self.chess.checkedMove(notationToMove("c3c2", Color.Black))
    self.chess.checkedMove(notationToMove("d7d6", Color.White))
    self.chess.checkedMove(notationToMove("c2d2", Color.Black))
    self.chess.checkedMove(notationToMove("d6c6", Color.White))
    self.chess.checkedMove(notationToMove("d2c2", Color.Black))
    self.chess.checkedMove(notationToMove("c6d5", Color.White))
    self.chess.checkedMove(notationToMove("c2g2", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("g2g5", Color.Black))
    self.chess.checkedMove(notationToMove("d5c6", Color.White))
    self.chess.checkedMove(notationToMove("a7a6", Color.Black))
    self.chess.checkedMove(notationToMove("b1b8", Color.White))
    self.chess.checkedMove(notationToMove("g5g7", Color.Black))
    self.chess.checkedMove(notationToMove("b8b6", Color.White))
    self.chess.checkedMove(notationToMove("a6a7", Color.Black))
    self.chess.checkedMove(notationToMove("b6b1", Color.White))
    self.chess.checkedMove(notationToMove("a7a8", Color.Black))
    self.chess.checkedMove(notationToMove("b1e1", Color.White))
    self.chess.checkedMove(notationToMove("g7b7", Color.Black))
    self.chess.checkedMove(notationToMove("e1e8", Color.White))
    self.chess.checkedMove(notationToMove("a8a7", Color.Black))
    self.chess.checkedMove(notationToMove("d6c5", Color.White))
    self.check(self.chess.isDrawClaimable())

  method testIsDrawClaimableFiftyMoveRuleFalseNinetyFour() =
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      WBishop, 0, 0, 0, 0, 0, 0, 0,
      0, 0, WKing, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, WRook, 0,
      0, 0, 0, BKing, 0, 0, 0, 0
    ], Color.Black)
    self.chess.checkedMove(notationToMove("a2a5", Color.Black))
    self.chess.checkedMove(notationToMove("f5g6", Color.White))
    self.chess.checkedMove(notationToMove("a5e5", Color.Black))
    self.chess.checkedMove(notationToMove("h4f6", Color.White))
    self.chess.checkedMove(notationToMove("e5e2", Color.Black))
    self.chess.checkedMove(notationToMove("b7a7", Color.White))
    self.chess.checkedMove(notationToMove("e2e1", Color.Black))
    self.chess.checkedMove(notationToMove("g6f5", Color.White))
    self.chess.checkedMove(notationToMove("e1b1", Color.Black))
    self.chess.checkedMove(notationToMove("f6d4", Color.White))
    self.chess.checkedMove(notationToMove("e8d8", Color.Black))
    self.chess.checkedMove(notationToMove("f5e6", Color.White))
    self.chess.checkedMove(notationToMove("d8c8", Color.Black))
    self.chess.checkedMove(notationToMove("d4e5", Color.White))
    self.chess.checkedMove(notationToMove("b1c1", Color.Black))
    self.chess.checkedMove(notationToMove("a7f7", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("c2c1", Color.Black))
    self.chess.checkedMove(notationToMove("e6d5", Color.White))
    self.chess.checkedMove(notationToMove("c1a1", Color.Black))
    self.chess.checkedMove(notationToMove("f7h7", Color.White))
    self.chess.checkedMove(notationToMove("a1a2", Color.Black))
    self.chess.checkedMove(notationToMove("d6f4", Color.White))
    self.chess.checkedMove(notationToMove("a2a6", Color.Black))
    self.chess.checkedMove(notationToMove("f4e5", Color.White))
    self.chess.checkedMove(notationToMove("a6b6", Color.Black))
    self.chess.checkedMove(notationToMove("h7c7", Color.White))
    self.chess.checkedMove(notationToMove("c8d8", Color.Black))
    self.chess.checkedMove(notationToMove("c7a7", Color.White))
    self.chess.checkedMove(notationToMove("d8c8", Color.Black))
    self.chess.checkedMove(notationToMove("a7c7", Color.White))
    self.chess.checkedMove(notationToMove("c8d8", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("b6b1", Color.Black))
    self.chess.checkedMove(notationToMove("c7a7", Color.White))
    self.chess.checkedMove(notationToMove("b1e1", Color.Black))
    self.chess.checkedMove(notationToMove("d6e5", Color.White))
    self.chess.checkedMove(notationToMove("e1d1", Color.Black))
    self.chess.checkedMove(notationToMove("d5e6", Color.White))
    self.chess.checkedMove(notationToMove("d1c1", Color.Black))
    self.chess.checkedMove(notationToMove("a7b7", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("b7b3", Color.White))
    self.chess.checkedMove(notationToMove("c2c6", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("c6c1", Color.Black))
    self.chess.checkedMove(notationToMove("b3h3", Color.White))
    self.chess.checkedMove(notationToMove("d8c8", Color.Black))
    self.chess.checkedMove(notationToMove("h3h8", Color.White))
    self.chess.checkedMove(notationToMove("c8b7", Color.Black))
    self.chess.checkedMove(notationToMove("h8b8", Color.White))
    self.chess.checkedMove(notationToMove("b7a7", Color.Black))
    self.chess.checkedMove(notationToMove("b8b4", Color.White))
    self.chess.checkedMove(notationToMove("c1d1", Color.Black))
    self.chess.checkedMove(notationToMove("e6d7", Color.White))
    self.chess.checkedMove(notationToMove("d1c1", Color.Black))
    self.chess.checkedMove(notationToMove("d6c7", Color.White))
    self.chess.checkedMove(notationToMove("c1h1", Color.Black))
    self.chess.checkedMove(notationToMove("c7f4", Color.White))
    self.chess.checkedMove(notationToMove("h1h3", Color.Black))
    self.chess.checkedMove(notationToMove("f4e5", Color.White))
    self.chess.checkedMove(notationToMove("h3h1", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("h1c1", Color.Black))
    self.chess.checkedMove(notationToMove("d6f4", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("f4c7", Color.White))
    self.chess.checkedMove(notationToMove("c2c1", Color.Black))
    self.chess.checkedMove(notationToMove("b4b5", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("b5b6", Color.White))
    self.chess.checkedMove(notationToMove("c2g2", Color.Black))
    self.chess.checkedMove(notationToMove("b6b3", Color.White))
    self.chess.checkedMove(notationToMove("g2c2", Color.Black))
    self.chess.checkedMove(notationToMove("b3b1", Color.White))
    self.chess.checkedMove(notationToMove("c2c3", Color.Black))
    self.chess.checkedMove(notationToMove("c7e5", Color.White))
    self.chess.checkedMove(notationToMove("c3c2", Color.Black))
    self.chess.checkedMove(notationToMove("d7d6", Color.White))
    self.chess.checkedMove(notationToMove("c2d2", Color.Black))
    self.chess.checkedMove(notationToMove("d6c6", Color.White))
    self.chess.checkedMove(notationToMove("d2c2", Color.Black))
    self.chess.checkedMove(notationToMove("c6d5", Color.White))
    self.chess.checkedMove(notationToMove("c2g2", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("g2g5", Color.Black))
    self.chess.checkedMove(notationToMove("d5c6", Color.White))
    self.chess.checkedMove(notationToMove("a7a6", Color.Black))
    self.chess.checkedMove(notationToMove("b1b8", Color.White))
    self.chess.checkedMove(notationToMove("g5g7", Color.Black))
    self.chess.checkedMove(notationToMove("b8b6", Color.White))
    self.chess.checkedMove(notationToMove("a6a7", Color.Black))
    self.chess.checkedMove(notationToMove("b6b1", Color.White))
    self.chess.checkedMove(notationToMove("a7a8", Color.Black))
    self.chess.checkedMove(notationToMove("b1e1", Color.White))
    self.chess.checkedMove(notationToMove("g7b7", Color.Black))
    self.chess.checkedMove(notationToMove("e1e8", Color.White))
    self.chess.checkedMove(notationToMove("a8a7", Color.Black))
    self.chess.checkedMove(notationToMove("d6c5", Color.White))
    self.check(self.chess.isDrawClaimable())

  method testIsDrawClaimableFiftyMoveRuleFalseCapture() =
    self.chess = initChess([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, BRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      WBishop, 0, 0, 0, 0, 0, 0, 0,
      0, 0, WKing, 0, 0, 0, 0, 0,
      0, 0, BPawn, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, WRook, 0,
      0, 0, 0, BKing, 0, 0, 0, 0
    ], Color.Black)
    self.chess.checkedMove(notationToMove("a2a5", Color.Black))
    self.chess.checkedMove(notationToMove("f5g6", Color.White))
    self.chess.checkedMove(notationToMove("a5e5", Color.Black))
    self.chess.checkedMove(notationToMove("h4f6", Color.White))
    self.chess.checkedMove(notationToMove("e5e2", Color.Black))
    self.chess.checkedMove(notationToMove("b7a7", Color.White))
    self.chess.checkedMove(notationToMove("e2e1", Color.Black))
    self.chess.checkedMove(notationToMove("g6f5", Color.White))
    self.chess.checkedMove(notationToMove("e1b1", Color.Black))
    self.chess.checkedMove(notationToMove("f6d4", Color.White))
    self.chess.checkedMove(notationToMove("e8d8", Color.Black))
    self.chess.checkedMove(notationToMove("f5e6", Color.White))
    self.chess.checkedMove(notationToMove("d8c8", Color.Black))
    self.chess.checkedMove(notationToMove("d4e5", Color.White))
    self.chess.checkedMove(notationToMove("b1c1", Color.Black))
    self.chess.checkedMove(notationToMove("a7f7", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("c2c1", Color.Black))
    self.chess.checkedMove(notationToMove("e6d5", Color.White))
    self.chess.checkedMove(notationToMove("c1a1", Color.Black))
    self.chess.checkedMove(notationToMove("f7h7", Color.White))
    self.chess.checkedMove(notationToMove("a1a2", Color.Black))
    self.chess.checkedMove(notationToMove("d6f4", Color.White))
    self.chess.checkedMove(notationToMove("a2a6", Color.Black))
    self.chess.checkedMove(notationToMove("f4e5", Color.White))
    self.chess.checkedMove(notationToMove("a6b6", Color.Black))
    self.chess.checkedMove(notationToMove("h7c7", Color.White))
    self.chess.checkedMove(notationToMove("c8d8", Color.Black))
    self.chess.checkedMove(notationToMove("c7a7", Color.White))
    self.chess.checkedMove(notationToMove("d8c8", Color.Black))
    self.chess.checkedMove(notationToMove("a7c7", Color.White))
    self.chess.checkedMove(notationToMove("c8d8", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("b6b1", Color.Black))
    self.chess.checkedMove(notationToMove("c7a7", Color.White))
    self.chess.checkedMove(notationToMove("b1e1", Color.Black))
    self.chess.checkedMove(notationToMove("d6e5", Color.White))
    self.chess.checkedMove(notationToMove("e1d1", Color.Black))
    self.chess.checkedMove(notationToMove("d5e6", Color.White))
    self.chess.checkedMove(notationToMove("d1c1", Color.Black))
    self.chess.checkedMove(notationToMove("a7b7", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("b7b3", Color.White))
    self.chess.checkedMove(notationToMove("c2c6", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("c6c1", Color.Black))
    self.chess.checkedMove(notationToMove("b3h3", Color.White))
    self.chess.checkedMove(notationToMove("d8c8", Color.Black))
    self.chess.checkedMove(notationToMove("h3h8", Color.White))
    self.chess.checkedMove(notationToMove("c8b7", Color.Black))
    self.chess.checkedMove(notationToMove("h8b8", Color.White))
    self.chess.checkedMove(notationToMove("b7a7", Color.Black))
    self.chess.checkedMove(notationToMove("b8b4", Color.White))
    self.chess.checkedMove(notationToMove("c1d1", Color.Black))
    self.chess.checkedMove(notationToMove("e6d7", Color.White))
    self.chess.checkedMove(notationToMove("d1c1", Color.Black))
    self.chess.checkedMove(notationToMove("d6c7", Color.White))
    self.chess.checkedMove(notationToMove("c1h1", Color.Black))
    self.chess.checkedMove(notationToMove("c7f4", Color.White))
    self.chess.checkedMove(notationToMove("h1h3", Color.Black))
    self.chess.checkedMove(notationToMove("f4e5", Color.White))
    self.chess.checkedMove(notationToMove("h3h1", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("h1c1", Color.Black))
    self.chess.checkedMove(notationToMove("d6f4", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("f4c7", Color.White))
    self.chess.checkedMove(notationToMove("c2c1", Color.Black))
    self.chess.checkedMove(notationToMove("b4b5", Color.White))
    self.chess.checkedMove(notationToMove("c1c2", Color.Black))
    self.chess.checkedMove(notationToMove("b5b6", Color.White))
    self.chess.checkedMove(notationToMove("c2g2", Color.Black))
    self.chess.checkedMove(notationToMove("b6b3", Color.White))
    self.chess.checkedMove(notationToMove("g2c2", Color.Black))
    self.chess.checkedMove(notationToMove("b3b1", Color.White))
    self.chess.checkedMove(notationToMove("c2c3", Color.Black))
    self.chess.checkedMove(notationToMove("c7e5", Color.White))
    self.chess.checkedMove(notationToMove("c3c2", Color.Black))
    self.chess.checkedMove(notationToMove("d7d6", Color.White))
    self.chess.checkedMove(notationToMove("c2d2", Color.Black))
    self.chess.checkedMove(notationToMove("d6c6", Color.White))
    self.chess.checkedMove(notationToMove("d2c2", Color.Black))
    self.chess.checkedMove(notationToMove("c6d5", Color.White))
    self.chess.checkedMove(notationToMove("c2g2", Color.Black))
    self.chess.checkedMove(notationToMove("e5d6", Color.White))
    self.chess.checkedMove(notationToMove("g2g5", Color.Black))
    self.chess.checkedMove(notationToMove("d5c6", Color.White))
    self.chess.checkedMove(notationToMove("a7a6", Color.Black))
    self.chess.checkedMove(notationToMove("b1b8", Color.White))
    self.chess.checkedMove(notationToMove("g5g7", Color.Black))
    self.chess.checkedMove(notationToMove("b8b6", Color.White))
    self.chess.checkedMove(notationToMove("a6a7", Color.Black))
    self.chess.checkedMove(notationToMove("b6b1", Color.White))
    self.chess.checkedMove(notationToMove("a7a8", Color.Black))
    self.chess.checkedMove(notationToMove("b1e1", Color.White))
    self.chess.checkedMove(notationToMove("g7b7", Color.Black))
    self.chess.checkedMove(notationToMove("e1e8", Color.White))
    self.chess.checkedMove(notationToMove("a8a7", Color.Black))
    self.chess.checkedMove(notationToMove("d6c5", Color.White))
    self.check(not self.chess.isDrawClaimable())

  ## Tests for Pawn moves
  method testCheckedMovePawnSingleTrue() =
    self.setup()
    var test: bool
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
      self.check(test)
      test = self.chess.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
      self.check(test)
      test = self.chess.checkedMove(notationToMove($file & "3" & $file & "4", Color.White))
      self.check(test)
      test = self.chess.checkedMove(notationToMove($file & "6" & $file & "5", Color.Black))
      self.check(test)

  method testCheckedMovePawnSingleFalseIntoEnemyPiece() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "4" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "5" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnSingleFalseIntoOwnPiece() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleTrue() =
    self.setup()
    var test: bool
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "2" & $file & "4", Color.White))
      self.check(test)
      test = self.chess.checkedMove(notationToMove($file & "7" & $file & "5", Color.Black))
      self.check(test)

  method testCheckedMovePawnDoubleFalseAlreadyMoved() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      0, 0, 0, 0, 0, 0, 0, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseThroughEnemyPiece() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseThroughOwnPiece() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseIntoEnemyPiece() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseIntoOwnPiece() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnCaptureTrueWhite() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "5", Color.White))
        self.check(test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "5", Color.White))
        self.check(test)

  method testCheckedMovePawnCaptureTrueBlack() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "4", Color.Black))
        self.check(test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "4", Color.Black))
        self.check(test)

  method testCheckedMovePawnCaptureFalseWhite() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "5", Color.White))
        self.check(not test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "5", Color.White))
        self.check(not test)

  method testCheckedMovePawnCaptureFalseBlack() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "4", Color.Black))
        self.check(not test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "4", Color.Black))
        self.check(not test)

  method testCheckedMovePawnEnPassantTrueWhite() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "2" & $file & "4", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "4" & $file & "5", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($str[ind+1] & "7" & $str[
            ind+1] & "5", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "6", Color.White))
        self.check(test)
        test = (0 == self.chess.board[fieldToInd($str[ind+1] & "5")])
        self.check(test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "2" & $file & "4", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "4" & $file & "5", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($str[ind+1] & "7" & $str[
            ind+1] & "5", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "6", Color.White))
        self.check(test)
        test = (0 == self.chess.board[fieldToInd($str[ind+1] & "5")])
        self.check(test)

  method testCheckedMovePawnEnPassantTrueBlack() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "7" & $file & "5", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "5" & $file & "4", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($str[ind+1] & "2" & $str[
            ind+1] & "4", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "3", Color.Black))
        self.check(test)
        test = (0 == self.chess.board[fieldToInd($str[ind+1] & "4")])
        self.check(test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "7" & $file & "5", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "5" & $file & "4", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($str[ind+1] & "2" & $str[
            ind+1] & "4", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "3", Color.Black))
        self.check(test)
        test = (0 == self.chess.board[fieldToInd($str[ind+1] & "4")])
        self.check(test)

  method testCheckedMovePawnEnPassantFalseWhite() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "2" & $file & "4", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($str[ind+1] & "7" & $str[
            ind+1] & "5", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "4" & $file & "5", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "6", Color.White))
        self.check(not test)
        test = (0 == self.chess.board[fieldToInd($str[ind+1] & "5")])
        self.check(not test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "2" & $file & "4", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($str[ind+1] & "7" & $str[
            ind+1] & "5", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "4" & $file & "5", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "7" & $file & "6", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "5" & $str[ind+1] &
            "6", Color.White))
        self.check(not test)
        test = (0 == self.chess.board[fieldToInd($str[ind+1] & "5")])
        self.check(not test)

  method testCheckedMovePawnEnPassantFalseBlack() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "7" & $file & "5", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($str[ind+1] & "2" & $str[
            ind+1] & "4", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "5" & $file & "4", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "3", Color.Black))
        self.check(not test)
        test = (0 == self.chess.board[fieldToInd($str[ind+1] & "4")])
        self.check(not test)
    str.reverse()
    for ind, file in str:
      if ind < len(str)-1:
        self.chess = pos
        test = self.chess.checkedMove(notationToMove($file & "7" & $file & "5", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($str[ind+1] & "2" & $str[
            ind+1] & "4", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "5" & $file & "4", Color.Black))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "2" & $file & "3", Color.White))
        self.check(test)
        test = self.chess.checkedMove(notationToMove($file & "4" & $str[ind+1] &
            "3", Color.Black))
        self.check(not test)
        test = (0 == self.chess.board[fieldToInd($str[ind+1] & "4")])
        self.check(not test)

  ## Tests for King moves
  method testCheckedMoveKingCastleTrueWhite() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(test)
    self.chess = pos
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(test)

  method testCheckedMoveKingCastleTrueBlack() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.Black)
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(test)
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(test)

  method testCheckedMoveKingCastleFalseAlreadyMovedKing() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, 0, WKing, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, 0, 0, BKing, 0, 0, BRook
    ], Color.White)
    self.chess.checkedMove(notationToMove("d1e1", Color.White))
    self.chess.checkedMove(notationToMove("d8e8", Color.White))
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseAlreadyMovedRook() =
    var test: bool
    let pos = initChess([
      0, WRook, 0, WKing, 0, 0, WRook, 0,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      0, BRook, 0, BKing, 0, 0, BRook, 0
    ], Color.White)
    self.chess = pos
    self.chess.checkedMove(notationToMove("b1a1", Color.White))
    self.chess.checkedMove(notationToMove("b8a8", Color.Black))
    self.chess.checkedMove(notationToMove("g1h1", Color.White))
    self.chess.checkedMove(notationToMove("g8h8", Color.Black))
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseThroughCheck() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, WPawn, BRook, WPawn, BRook, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, WRook, BPawn, WRook, BPawn, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseIntoCheck() =
    var test: bool
    let pos = initChess([
      WRook, 0, 0, WKing, 0, 0, 0, WRook,
      WPawn, BRook, WPawn, WPawn, WPawn, BRook, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, WRook, BPawn, BPawn, BPawn, WRook, BPawn, BPawn,
      BRook, 0, 0, BKing, 0, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseThroughOwnPiece() =
    var test: bool
    let pos = initChess([
      WRook, 0, WBishop, WKing, WBishop, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, BBishop, BKing, BBishop, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseThroughEnemyPiece() =
    var test: bool
    let pos = initChess([
      WRook, 0, BBishop, WKing, BBishop, 0, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, 0, WBishop, BKing, WBishop, 0, 0, BRook
    ], Color.White)
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseIntoOwnPiece() =
    var test: bool
    let pos = initChess([
      WRook, WBishop, 0, WKing, 0, WBishop, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, BBishop, 0, BKing, 0, BBishop, 0, BRook
    ], Color.White)
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseIntoEnemyPiece() =
    var test: bool
    let pos = initChess([
      WRook, BBishop, 0, WKing, 0, BBishop, 0, WRook,
      WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn,
      BRook, WBishop, 0, BKing, 0, WBishop, 0, BRook
    ], Color.White)
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingWhite() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        move = $cha & $num
        test = self.chess.checkedMove(notationToMove(start & move, Color.White))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  method testCheckedMoveKingBlack() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        move = $cha & $num
        test = self.chess.checkedMove(notationToMove(start & move, Color.Black))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  ## Tests for Bishop moves
  method testCheckedMoveBishopWhite() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        move = $cha & $num
        test = self.chess.checkedMove(notationToMove(start & move, Color.White))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  method testCheckedMoveBishopBlack() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        move = $cha & $num
        test = self.chess.checkedMove(notationToMove(start & move, Color.Black))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  ## Tests for Knight moves
  method testCheckedMoveKnightWhite() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        move = $cha & $num
        test = self.chess.checkedMove(notationToMove(start & move, Color.White))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  method testCheckedMoveKnightBlack() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        move = $cha & $num
        test = self.chess.checkedMove(notationToMove(start & move, Color.Black))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  ## Tests for Rook moves
  method testCheckedMoveRookWhite() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        move = $cha & $num
        test = self.chess.checkedMove(notationToMove(start & move, Color.White))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  method testCheckedMoveRookBlack() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        move = $cha & $num
        test = self.chess.checkedMove(notationToMove(start & move, Color.Black))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  ## Tests for Queen moves
  method testCheckedMoveQueenWhite() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        move = $cha & $num
        test = self.chess.checkedMove(notationToMove(start & move, Color.White))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  method testCheckedMoveQueenBlack() =
    var test: bool
    let pos = initChess([
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
        self.chess = pos
        move = $cha & $num
        test = self.chess.checkedMove(notationToMove(start & move, Color.Black))
        if move in legalMoves:
          self.check(test)
        else:
          self.check(not test)

  method testcheckedMoveFaultyInput() =
    var test: bool
    self.setup()
    let startPos = self.chess
    test = self.chess.checkedMove(notationToMove("aaaa", Color.White))
    self.check(not test)
    test = (self.chess == startPos)
    self.check(test)
    test = self.chess.checkedMove(notationToMove("1bb6&111", Color.White))
    self.check(not test)
    test = (self.chess == startPos)
    self.check(test)
    test = self.chess.checkedMove(notationToMove("e1g1sdfa", Color.White))
    self.check(not test)
    test = (self.chess == startPos)
    self.check(test)

when isMainModule:
  einheit.runTests()
