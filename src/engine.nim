import algorithm

import ./chess.nim

type
  MoveTree = object
    ## `Movetree` is a visualization for possible moves.
    chess: Chess
    evaluation: float
    children: seq[Movetree]

const
  PawnVal = 10          ## `PawnVal` is the engines value for a pawn.
  KnightVal = 31        ## `KnightVal` is the engines value for a knight.
  BishopVal = 33        ## `BishopVal` is the engines value for a bishop.
  RookVal = 50          ## `RookVal` is the engines value for a rook.
  QueenVal = 90         ## `QueenVal` is the engines value for a queen.
  CheckmateVal = -10000 ## `CheckmateVal` is the engines value for a checkmate.
  DrawVal = 0           ## `DrawVal` is the engines value for a draw.
  LoVal = -1000000      ## `LoVal` is a value always lower than  any evaluation.
  pawnTable = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 5, 10, 10, -20, -20, 10, 10, 5, 0,
    0, 5, -5, -10, 0, 0, -10, -5, 5, 0,
    0, 0, 0, 0, 20, 20, 0, 0, 0, 0,
    0, 5, 5, 10, 25, 25, 10, 5, 5, 0,
    0, 10, 10, 20, 30, 30, 20, 10, 10, 0,
    0, 50, 50, 50, 50, 50, 50, 50, 50, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  ]                     ## `pawnTable` is the piece-square table for pawns.
  knightTable = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, -50, -40, -30, -30, -30, -30, -40, -50, 0,
    0, -40, -20, 0, 5, 5, 0, -20, -40, 0,
    0, -30, 0, 10, 15, 15, 10, 0, -30, 0,
    0, -30, 5, 15, 20, 20, 15, 5, -30, 0,
    0, -30, 0, 15, 20, 20, 15, 0, -30, 0,
    0, -30, 5, 10, 15, 15, 10, 5, -30, 0,
    0, -40, -20, 0, 0, 0, 0, -20, -40, 0,
    0, -50, -40, -30, -30, -30, -30, -40, -50, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  ]                     ## `knightTable` is the piece-square table for pawns.
  bishopTable = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, -20, -10, -10, -10, -10, -10, -10, -20, 0,
    0, -10, 5, 0, 0, 0, 0, 5, -10, 0,
    0, -10, 10, 10, 10, 10, 10, 10, -10, 0,
    0, -10, 0, 10, 10, 10, 10, 0, -10, 0,
    0, -10, 5, 5, 10, 10, 5, 5, -10, 0,
    0, -10, 0, 5, 10, 10, 5, 0, -10, 0,
    0, -10, 0, 0, 0, 0, 0, 0, -10, 0,
    0, -20, -10, -10, -10, -10, -10, -10, -20, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  ]                     ## `bishopTable` is the piece-square table for pawns.
  rookTable = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 5, 5, 0, 0, 0, 0,
    0, -5, 0, 0, 0, 0, 0, 0, -5, 0,
    0, -5, 0, 0, 0, 0, 0, 0, -5, 0,
    0, -5, 0, 0, 0, 0, 0, 0, -5, 0,
    0, -5, 0, 0, 0, 0, 0, 0, -5, 0,
    0, -5, 0, 0, 0, 0, 0, 0, -5, 0,
    0, 5, 10, 10, 10, 10, 10, 10, 5, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  ]                     ## `rookTable` is the piece-square table for pawns.
  queenTable = [
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, -20, -10, -10, -5, -5, -10, -10, -20, 0,
     0, -10, 0, 0, 0, 0, 5, 0, -10, 0,
     0, -10, 0, 5, 5, 5, 5, 0, -10, 0,
     0, -10, 0, 5, 5, 5, 5, 0, -10, 0,
     0, -10, 0, 5, 5, 5, 5, 0, -10, 0,
     0, -10, 0, 5, 5, 5, 5, 0, -10, 0,
     0, -10, 0, 0, 0, 0, 0, 0, -10, 0,
     0, -20, -10, -10, -5, -5, -10, -10, -20, 0,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    ]                   ## `queenTable` is the piece-square table for pawns.
  kingTable = [
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 20, 30, 10, 0, 0, 10, 30, 20, 0,
     0, 20, 20, 0, 0, 0, 0, 20, 20, 0,
     0, -10, -20, -20, -20, -20, -20, -20, -10, 0,
     0, -20, -30, -30, -40, -40, -30, -30, -20, 0,
     0, -30, -40, -40, -50, -50, -40, -40, -30, 0,
     0, -30, -40, -40, -50, -50, -40, -40, -30, 0,
     0, -30, -40, -40, -50, -50, -40, -40, -30, 0,
     0, -30, -40, -40, -50, -50, -40, -40, -30, 0,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    ]                   ## `kingTable` is the piece-square table for pawns.

proc pieceEval(chess: Chess): int =
  ## Returns the evaluation of existing pieces on the `board`
  var evaluation = DrawVal
  for ind, square in chess.board:
    case square:
      of WPawn:
        evaluation += ord(Color.White) * PawnVal
        evaluation += ord(Color.White) * pawnTable[ind]
      of WKnight:
        evaluation += ord(Color.White) * KnightVal
        evaluation += ord(Color.White) * knightTable[ind]
      of WBishop:
        evaluation += ord(Color.White) * BishopVal
        evaluation += ord(Color.White) * bishopTable[ind]
      of WRook:
        evaluation += ord(Color.White) * RookVal
        evaluation += ord(Color.White) * rookTable[ind]
      of WQueen:
        evaluation += ord(Color.White) * QueenVal
        evaluation += ord(Color.White) * queenTable[ind]
      of WKing:
        evaluation += ord(Color.White) * kingTable[ind]
      of BPawn:
        evaluation += ord(Color.Black) * PawnVal
        evaluation += ord(Color.Black) * pawnTable.reversed[ind]
      of BKnight:
        evaluation += ord(Color.Black) * KnightVal
        evaluation += ord(Color.Black) * knightTable.reversed[ind]
      of BBishop:
        evaluation += ord(Color.Black) * BishopVal
        evaluation += ord(Color.Black) * bishopTable.reversed[ind]
      of BRook:
        evaluation += ord(Color.Black) * RookVal
        evaluation += ord(Color.Black) * rookTable.reversed[ind]
      of BQueen:
        evaluation += ord(Color.Black) * QueenVal
        evaluation += ord(Color.Black) * queenTable.reversed[ind]
      of BKing:
        evaluation += ord(Color.White) * kingTable.reversed[ind]
      else:
        continue
  return evaluation

proc evaluate(chess: Chess): int =
  ## Returns a complete evaluation of a `chess` with player `toMove` about to make
  ## a move.
  var evaluation: int
  if chess.isCheckmate(chess.toMove):
    evaluation = ord(chess.toMove) * CheckmateVal
  if chess.isStalemate(chess.toMove):
    evaluation = DrawVal
  else:
    evaluation = chess.pieceEval()
    if chess.isDrawClaimable():
      if chess.toMove == Color.White:
        evaluation = max(DrawVal, evaluation)
      else:
        evaluation = min(DrawVal, evaluation)
  return evaluation

proc spanMoveTree(chess: Chess, depth: int): MoveTree =
  ## Create and return a Movetree of a given `chess` with a given maximum `depth`.
  var mTree: MoveTree
  mTree.chess = chess
  if depth != 0 and not chess.isCheckmate(chess.toMove) and
      not chess.isStalemate(chess.toMove):
    let possibleMoves = chess.genLegalMoves(chess.toMove)
    for move in possibleMoves:
      var tmpChess = chess
      tmpChess.checkedMove(move)
      mTree.children.add(spanMoveTree(tmpChess, depth-1))
  return mTree

proc negaMax(mTree: MoveTree): int =
  ## Return the value of the root node of a given `MoveTree`
  if mTree.children == []:
    return mTree.chess.evaluate()
  var bestVal = LoVal
  for child in mTree.children:
    var tmpVal = -negaMax(child)
    bestVal = max(bestVal, tmpVal)
  return bestVal

proc bestMove*(chess: Chess, depth: int): Move =
  ## Generate a MoveTree of a `chess` with a given `depth`, run negaMax and return
  ## the best evaluated move.
  var moves = chess.genLegalMoves(chess.toMove)
  var bestMove: Move
  var bestEval: int
  bestEval = LoVal
  for move in moves:
    var tmpChess = chess
    tmpChess.checkedMove(move)
    var tmpMTree = tmpChess.spanMoveTree(depth)
    var tmpEval = -tmpMTree.negaMax()
    echo("move:", moveToNotation(move), "; eval:", tmpEval)
    if tmpEval > bestEval:
      bestEval = tmpEval
      bestMove = move
  return bestMove
