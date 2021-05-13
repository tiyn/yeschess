import einheit
import algorithm

include ./chess.nim

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
    self.chess = initChess("8/5kp1/8/5b2/1p6/n1p1p1p1/Kbpp2p1/nrqr4 w - - 0 0")
    self.check(self.chess.isStalemate(Color.White))

  method testIsStalemateTrueBlack() =
    self.chess = initChess("8/5KP1/8/5B2/1P6/N1P1P1P1/kBPP2P1/NRQR4 b - - 0 0")
    self.check(self.chess.isStalemate(Color.Black))

  method testIsStalemateInsufficientMaterialTrue() =
    self.chess = initChess("8/2k5/8/8/8/8/4K3/8 b - - 0 0")
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess("8/2k5/8/5N2/N7/8/4K3/8 b - - 0 0")
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess("8/2k5/8/5n2/n7/8/4K3/8 b - - 0 0")
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess("8/2k5/8/8/n7/8/4K3/8 b - - 0 0")
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess("8/2k5/8/8/N7/8/4K3/8 b - - 0 0")
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess("8/2k5/8/8/b7/8/4K3/8 b - - 0 0")
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))
    self.chess = initChess("8/2k5/8/8/B7/8/4K3/8 b - - 0 0")
    self.check(self.chess.isStalemate(Color.Black))
    self.check(self.chess.isStalemate(Color.White))

  method testIsStalemateInsufficientMaterialFalse() =
    self.chess = initChess("8/2k5/8/8/p7/8/4K3/8 b - - 0 0")
    self.check(not self.chess.isStalemate(Color.Black))
    self.check(not self.chess.isStalemate(Color.White))
    self.chess = initChess("8/2k5/8/8/P7/8/4K3/8 b - - 0 0")
    self.check(not self.chess.isStalemate(Color.Black))
    self.check(not self.chess.isStalemate(Color.White))
    self.chess = initChess("8/2k5/8/8/r7/8/4K3/8 b - - 0 0")
    self.check(not self.chess.isStalemate(Color.Black))
    self.check(not self.chess.isStalemate(Color.White))
    self.chess = initChess("8/2k5/8/8/R7/8/4K3/8 b - - 0 0")
    self.check(not self.chess.isStalemate(Color.Black))
    self.check(not self.chess.isStalemate(Color.White))
    self.chess = initChess("8/2k5/8/8/p5B1/8/4K3/8 b - - 0 0")
    self.check(not self.chess.isStalemate(Color.Black))
    self.check(not self.chess.isStalemate(Color.White))
    self.chess = initChess("8/2k5/8/8/P4b2/8/4K3/8 b - - 0 0")
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
    self.chess = initChess("4k3/1R6/8/5K2/7B/8/r7/8 b - - 0 0")
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
    self.chess = initChess("4k3/1R6/8/5K2/7B/8/r7/8 b - - 0 0")
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
    self.chess = initChess("4k3/1R6/5p2/5K2/7B/8/r7/8 b - - 0 0")
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
    self.chess = initChess("r3k2r/8/8/pppppppp/PPPPPPPP/8/8/R3K2R w - - 0 0")
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "4" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "5" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnSingleFalseIntoOwnPiece() =
    var test: bool
    self.chess = initChess("r3k2r/pppppppp/pppppppp/8/8/PPPPPPPP/PPPPPPPP/R3K2R w - - 0 0")
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
    self.chess = initChess("r3k2r/8/pppppppp/8/8/PPPPPPPP/8/R3K2R w - - 0 0")
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseThroughEnemyPiece() =
    var test: bool
    self.chess = initChess("r3k2r/pppppppp/PPPPPPPP/8/8/pppppppp/PPPPPPPP/R3K2R w - - 0 0")
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseThroughOwnPiece() =
    var test: bool
    self.chess = initChess("r3k2r/pppppppp/pppppppp/8/8/PPPPPPPP/PPPPPPPP/R3K2R w - - 0 0")
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseIntoEnemyPiece() =
    var test: bool
    self.chess = initChess("r3k2r/pppppppp/8/PPPPPPPP/pppppppp/8/PPPPPPPP/R3K2R w - - 0 0")
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnDoubleFalseIntoOwnPiece() =
    var test: bool
    self.chess = initChess("r3k2r/pppppppp/8/pppppppp/PPPPPPPP/8/PPPPPPPP/R3K2R w - - 0 0")
    for file in "abcdefgh":
      test = self.chess.checkedMove(notationToMove($file & "3" & $file & "5", Color.White))
      self.check(not test)
      test = self.chess.checkedMove(notationToMove($file & "6" & $file & "4", Color.Black))
      self.check(not test)

  method testCheckedMovePawnCaptureTrueWhite() =
    var test: bool
    let pos = initChess("r3k2r/8/8/pppppppp/PPPPPPPP/8/8/R3K2R w - - 0 0")
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
    let pos = initChess("r3k2r/8/8/pppppppp/PPPPPPPP/8/8/R3K2R b - - 0 0")
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
    let pos = initChess("r3k2r/8/8/8/PPPPPPPP/8/8/R3K2R w - - 0 0")
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
    let pos = initChess("r3k2r/8/8/pppppppp/8/8/8/R3K2R b - - 0 0")
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
    let pos = initChess("r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w - - 0 0")
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
    let pos = initChess("r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R b - - 0 0")
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
    let pos = initChess("r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w - - 0 0")
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
    let pos = initChess("r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R b - - 0 0")
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
    let pos = initChess("r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w KQkq - 0 0")
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(test)
    self.check(self.chess.board[fieldToInd("c1")] == WKing)
    self.check(self.chess.board[fieldToInd("d1")] == WRook)
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(test)
    self.check(self.chess.board[fieldToInd("g1")] == WKing)
    self.check(self.chess.board[fieldToInd("f1")] == WRook)

  method testCheckedMoveKingCastleTrueBlack() =
    var test: bool
    let pos = initChess("r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R b KQkq - 0 0")
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(test)
    self.check(self.chess.board[fieldToInd("c8")] == BKing)
    self.check(self.chess.board[fieldToInd("d8")] == BRook)
    self.chess = pos
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(test)
    self.check(self.chess.board[fieldToInd("g8")] == BKing)
    self.check(self.chess.board[fieldToInd("f8")] == BRook)

  method testCheckedMoveKingCastleFalseAlreadyMovedKing() =
    var test: bool
    var pos = initChess("r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R b KQkq - 0 0")
    pos.checkedMove(notationToMove("e8d8", Color.Black))
    pos.checkedMove(notationToMove("e1d1", Color.White))
    self.chess = pos
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
    var pos = initChess("r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w KQkq - 0 0")
    pos.checkedMove(notationToMove("a1b1", Color.White))
    pos.checkedMove(notationToMove("a8b8", Color.Black))
    pos.checkedMove(notationToMove("h1g1", Color.White))
    pos.checkedMove(notationToMove("h8g8", Color.Black))
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
    self.chess = initChess("r3k2r/pppRpRpp/8/8/8/8/PPPrPrPP/R3K2R w KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    self.chess = initChess("r3k2r/pppRpRpp/8/8/8/8/PPPrPrPP/R3K2R b KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseIntoCheck() =
    var test: bool
    self.chess = initChess("r3k2r/ppRpppRp/8/8/8/8/PPrPPPrP/R3K2R w KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    self.chess = initChess("r3k2r/ppRpppRp/8/8/8/8/PPrPPPrP/R3K2R b KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseThroughOwnPiece() =
    var test: bool
    self.chess = initChess("r2bkb1r/pppppppp/8/8/8/8/PPPPPPPP/R2BKB1R w KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    self.chess = initChess("r2bkb1r/pppppppp/8/8/8/8/PPPPPPPP/R2BKB1R b KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseThroughEnemyPiece() =
    var test: bool
    self.chess = initChess("r2BkB1r/pppppppp/8/8/8/8/PPPPPPPP/R2bKb1R w KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    self.chess = initChess("r2BkB1r/pppppppp/8/8/8/8/PPPPPPPP/R2bKb1R b KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseIntoOwnPiece() =
    var test: bool
    self.chess = initChess("r1b1k1br/pppppppp/8/8/8/8/PPPPPPPP/R1b1K1bR w KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    self.chess = initChess("r1b1k1br/pppppppp/8/8/8/8/PPPPPPPP/R1b1K1bR b KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingCastleFalseIntoEnemyPiece() =
    var test: bool
    self.chess = initChess("r1B1k1Br/pppppppp/8/8/8/8/PPPPPPPP/R1B1K1BR w KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e1c1", Color.White))
    self.check(not test)
    self.chess.checkedMove(notationToMove("e1g1", Color.White))
    self.check(not test)
    self.chess = initChess("r1B1k1Br/pppppppp/8/8/8/8/PPPPPPPP/R1B1K1BR b KQkq - 0 0")
    test = self.chess.checkedMove(notationToMove("e8c8", Color.Black))
    self.check(not test)
    test = self.chess.checkedMove(notationToMove("e8g8", Color.Black))
    self.check(not test)

  method testCheckedMoveKingWhite() =
    var test: bool
    let pos = initChess("8/8/8/3PKp2/8/8/8/8 w - f6 0 0")
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
    let pos = initChess("8/8/8/3pkP2/8/8/8/8 b - f6 0 0")
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
    let pos = initChess("8/8/4p3/3B4/2P5/8/8/8 w - c6 0 0")
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
    let pos = initChess("8/8/4P3/3b4/2p5/8/8/8 b - c6 0 0")
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
    let pos = initChess("8/8/5p2/3N4/8/2P5/8/8 w - f4 0 0")
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
    let pos = initChess("8/8/5P2/3n4/8/2p5/8/8 b - f4 0 0")
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
    let pos = initChess("8/8/8/3Rp3/3P4/8/8/8 w - c6 0 0")
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
    let pos = initChess("8/8/8/3rP3/3p4/8/8/8 b - c6 0 0")
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
    let pos = initChess("8/8/8/3Qp3/3P4/8/8/8 w - c6 0 0")
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
    let pos = initChess("8/8/8/3qP3/3p4/8/8/8 b - c6 0 0")
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
