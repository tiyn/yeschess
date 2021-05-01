import ./chess.nim

type
  MoveTree* = object
    ## `Movetree` is a visualization for possible moves.
    chess*: Chess
    evaluation: float
    children*: seq[Movetree]

const
  PawnVal = 1           ## `PawnVal` is the engines value for a pawn.
  KnightVal = 3         ## `KnightVal` is the engines value for a knight.
  BishopVal = 3         ## `BishopVal` is the engines value for a bishop.
  RookVal = 5           ## `RookVal` is the engines value for a rook.
  QueenVal = 9          ## `QueenVal` is the engines value for a queen.
  CheckmateVal = -1000  ## `CheckmateVal` is the engines value for a checkmate.
  DrawVal = 0           ## `DrawVal` is the engines value for a draw.
  LoVal = -1000000      ## `LoVal` is a value always lower than  any evaluation.

proc pieceEval*(chess: Chess): int =
  ## Returns the evaluation of existing pieces on the `board`
  var evaluation = DrawVal
  for square in chess.board:
    case square:
      of WPawn:
        evaluation += ord(Color.White) * PawnVal
      of WKnight:
        evaluation += ord(Color.White) * KnightVal
      of WBishop:
        evaluation += ord(Color.White) * BishopVal
      of WRook:
        evaluation += ord(Color.White) * RookVal
      of WQueen:
        evaluation += ord(Color.White) * QueenVal
      of BPawn:
        evaluation += ord(Color.Black) * PawnVal
      of BKnight:
        evaluation += ord(Color.Black) * KnightVal
      of BBishop:
        evaluation += ord(Color.Black) * BishopVal
      of BRook:
        evaluation += ord(Color.Black) * RookVal
      of BQueen:
        evaluation += ord(Color.Black) * QueenVal
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

proc spanMoveTree*(chess: Chess, depth: int): MoveTree =
  ## Create and return a Movetree of a given `chess` with a given maximum `depth`.
  var mTree: MoveTree
  mTree.chess = chess
  if depth != 0 and not chess.isCheckmate(chess.toMove) and not chess.isStalemate(chess.toMove):
    let possibleMoves = chess.genLegalMoves(chess.toMove)
    for move in possibleMoves:
      var tmpChess = chess
      tmpChess.checkedMove(move)
      mTree.children.add(spanMoveTree(tmpChess, depth-1))
  return mTree

proc negaMax*(mTree: MoveTree): int =
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
    echo("move:", moveToNotation(move),"; eval:", tmpEval)
    if tmpEval > bestEval:
      bestEval = tmpEval
      bestMove = move
  return bestMove
