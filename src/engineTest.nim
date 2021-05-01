import einheit

import ./chess
import ./engine

testSuite GameTest of TestSuite:

  var
    game: Game

  method setup() =
    self.game = initGame()

  method testPieceEvalStalemate() =
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
    var pieceEvaluation = self.game.pieceEval()
    self.check(pieceEvaluation == 0)

  method testSpanMoveTree() =
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
    var mTree = self.game.spanMoveTree(1)
    self.check(mTree.children == [])

  method testBestMoveProm() =
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WPawn, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.White)
    var testBestMove = self.game.bestMove(2)
    self.check(testBestMove.start != 0)
    self.check(indToField(testBestMove.start) == "e7")
    self.check(indToField(testBestMove.dest) == "e8")



  method testBestMoveStopProm() =
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, WPawn, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    var testBestMove = self.game.bestMove(2)
    self.check(testBestMove.start != 0)
    self.check(indToField(testBestMove.start) == "c7")
    self.check(indToField(testBestMove.dest) == "d7")

  method testBestMoveTacticBlack() =
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, WRook, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, WPawn, 0, 0, 0, 0, 0,
      0, BPawn, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, BRook, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    var testBestMove = self.game.bestMove(2)
    self.check(testBestMove.start != 0)
    self.check(indToField(testBestMove.start) != "g5" or indToField(testBestMove.dest) != "f4")

  method testBestMoveTacticWhite() =
    self.game = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, WRook, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, WPawn, 0, 0, 0, 0, 0, 0,
      0, 0, BPawn, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, BRook, 0, 0, 0, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.White)
    var testBestMove = self.game.bestMove(2)
    self.check(testBestMove.start != 0)
    self.check(indToField(testBestMove.start) != "g4" or indToField(testBestMove.dest) != "f5")


when isMainModule:
  einheit.runTests()