import einheit
import algorithm

import ./chess
import ./engine

testSuite GameTest of TestSuite:

  var
    game: Game

  method setup() =
    self.game = initGame()

  method testPieceEval() =
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
    var mTree = self.game.spanMoveTree(2)
    self.check(mTree.children == [])

  method testManualMiniMaxEval() =
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
    var mTree = self.game.spanMoveTree(2)
    var evaluation = mTree.minimax()
    self.check(evaluation == 0)

  method testBestMove() =
    var testGame = initGame([
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, WKing, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, WPawn, BKing, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    ], Color.Black)
    var testBestMove = testGame.bestMove(2)
    self.check(indToField(testBestMove.start) == "c7")
    self.check(indToField(testBestMove.dest) == "d7")


when isMainModule:
  einheit.runTests()
