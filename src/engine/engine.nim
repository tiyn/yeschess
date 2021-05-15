import algorithm

import chess

type
  MoveTree = object
    ## `Movetree` is a visualization for possible moves.
    chess: Chess
    evaluation: float
    children: seq[Movetree]

const
  PawnVal = 100          ## `PawnVal` is the engines value for a pawn.
  KnightVal = 310        ## `KnightVal` is the engines value for a knight.
  BishopVal = 330        ## `BishopVal` is the engines value for a bishop.
  RookVal = 500          ## `RookVal` is the engines value for a rook.
  QueenVal = 900         ## `QueenVal` is the engines value for a queen.
  CheckmateVal = -100000 ## `CheckmateVal` is the engines value for a checkmate.
  DrawVal = 0            ## `DrawVal` is the engines value for a draw.
  HiVal = 10000          ## `LoVal` is a value always lower than  any evaluation.
  LoVal = -HiVal         ## `LoVal` is a value always lower than  any evaluation.
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
    ]                    ## `kingTable` is the piece-square table for pawns.

proc pieceEval(chess: Chess): int =
  ## Returns the evaluation of existing pieces on the `board`
  var evaluation: int
  for ind, piece in chess.board:
    let tmpEval = case piece:
      of WPawn:
        ord(Color.White) * PawnVal + ord(Color.White) * pawnTable[ind]
      of WKnight:
        ord(Color.White) * KnightVal + ord(Color.White) * knightTable[ind]
      of WBishop:
        ord(Color.White) * BishopVal + ord(Color.White) * bishopTable[ind]
      of WRook:
        ord(Color.White) * RookVal + ord(Color.White) * rookTable[ind]
      of WQueen:
        ord(Color.White) * QueenVal + ord(Color.White) * queenTable[ind]
      of WKing:
        ord(Color.White) * kingTable[ind]
      of BPawn:
        ord(Color.Black) * PawnVal + ord(Color.Black) * pawnTable.reversed[ind]
      of BKnight:
        ord(Color.Black) * KnightVal + ord(Color.Black) * knightTable.reversed[ind]
      of BBishop:
        ord(Color.Black) * BishopVal + ord(Color.Black) * bishopTable.reversed[ind]
      of BRook:
        ord(Color.Black) * RookVal + ord(Color.Black) * rookTable.reversed[ind]
      of BQueen:
        ord(Color.Black) * QueenVal + ord(Color.Black) * queenTable.reversed[ind]
      of BKing:
        ord(Color.White) * kingTable.reversed[ind]
      else:
        DrawVal
    evaluation += tmpEval
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

proc negaMax(chess: Chess, depth: int, a: int, b: int): int =
  ## Return the value of a given `chess` with `depth` and `a` and `b` for alpha-beta
  ## pruning.
  var alpha = a
  var beta = b
  if depth <= 0 or chess.isCheckmate(chess.toMove) or chess.isStalemate(chess.toMove):
    return chess.evaluate()
  let possibleMoves = chess.genLegalMoves(chess.toMove)
  for move in possibleMoves:
    var tmpChess = chess
    tmpChess.checkedMove(move)
    var tmpVal = -negaMax(tmpChess, depth - 1, -beta, -alpha)
    if tmpVal >= beta:
      return beta
    if tmpVal > alpha:
      alpha = tmpVal
  return alpha

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
    var tmpEval = -tmpChess.negaMax(depth, LoVal, HiVal)
    echo("move:", moveToNotation(move, tmpChess.board), "; eval:", tmpEval)
    if tmpEval > bestEval:
      bestEval = tmpEval
      bestMove = move
  return bestMove
