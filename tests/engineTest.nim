import einheit

include chess
include engine/engine

testSuite ChessTest of TestSuite:

  var
    chess: Chess

  method setup() =
    self.chess = initChess()

  method testPieceEvalStalemate() =
    self.chess = initChess("8/8/2k5/8/8/5K2/8/8 b - - 0 1")
    var pieceEvaluation = self.chess.evaluate()
    self.check(pieceEvaluation == 0)

  method testBestMoveProm() =
    self.chess = initChess("8/2k1P3/8/8/8/5K2/8/8 w - - 0 1")
    var testBestMove = self.chess.bestMove(2)
    self.check(testBestMove.start != 0)
    self.check(indToField(testBestMove.start) == "e7")
    self.check(indToField(testBestMove.dest) == "e8")

  method testBestMoveStopProm() =
    self.chess = initChess("8/2k1P3/8/8/8/5K2/8/8 b - - 0 1")
    var testBestMove = self.chess.bestMove(2)
    self.check(testBestMove.start != 0)
    self.check(indToField(testBestMove.start) == "c7")
    self.check(indToField(testBestMove.dest) == "d7")

  method testBestMoveTacticBlack() =
    self.chess = initChess("8/2k3r1/8/6p1/5P2/8/4K1R1/8 b - - 0 1")
    var testBestMove = self.chess.bestMove(2)
    self.check(testBestMove.start != 0)
    self.check(indToField(testBestMove.start) != "g5" or indToField(
        testBestMove.dest) != "f4")

  method testBestMoveTacticWhite() =
    self.chess = initChess("8/2k3r1/8/5p2/6P1/8/4K1R1/8 w - - 0 1")
    var testBestMove = self.chess.bestMove(2)
    self.check(testBestMove.start != 0)
    self.check(indToField(testBestMove.start) != "g4" or indToField(
        testBestMove.dest) != "f5")

when isMainModule:
  einheit.runTests()
