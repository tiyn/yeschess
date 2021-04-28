import ./chess

type
  MoveTree* = object
    ## `Movetree` is a visualization for possible moves.
    game*: Game
    evaluation: float
    children*: seq[Movetree]

const
  PawnVal = 1           ## `PawnVal` is the engines value for a pawn.
  KnightVal = 3         ## `KnightVal` is the engines value for a knight.
  BishopVal = 3         ## `BishopVal` is the engines value for a bishop.
  RookVal = 5           ## `RookVal` is the engines value for a rook.
  QueenVal = 9          ## `QueenVal` is the engines value for a queen.
  CheckmateVal = 1000   ## `CheckmateVal` is the engines value for a checkmate.
  DrawVal = 0           ## `DrawVal` is the engines value for a draw.
  HiVal = 1000000       ## `HiVal` is the highest possible value (used in minimax).
  LoVal = -HiVal        ## `LoVal` is the lowest possible value (used in minimax).

proc pieceEval*(game: Game): int =
  ## Returns the evaluation of existing pieces on the `board`
  var evaluation = DrawVal
  for square in game.board:
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

proc evaluate(game: Game): int =
  ## Returns a complete evaluation of a `game` with player `toMove` about to make
  ## a move.
  var evaluation = game.pieceEval()
  return evaluation

proc spanMoveTree*(game: Game, depth: int): MoveTree =
  ## Create and return a Movetree of a given `game` with a given maximum `depth`.
  var mTree: MoveTree
  mTree.game = game
  if depth != 1 and not game.isCheckmate(game.toMove) and not game.isStalemate(game.toMove):
    let possibleMoves = game.genLegalMoves(game.toMove)
    for move in possibleMoves:
      var tmpGame = game
      tmpGame.checkedMove(move)
      mTree.children.add(spanMoveTree(tmpGame, depth-1))
  return mTree

proc minimax*(mTree: MoveTree): int =
  ## Return the value of the root node of a given `MoveTree`
  if mTree.children == []:
    return evaluate(mTree.game)
  var bestVal: int
  var tmpVal: int
  if mTree.game.toMove == Color.White:
    bestVal = LoVal
    for child in mTree.children:
      tmpVal = minimax(child)
      bestVal = max(bestVal, tmpVal)
  else:
    bestVal = HiVal
    for child in mTree.children:
      tmpVal = minimax(child)
      bestVal = min(bestVal, tmpVal)
  return bestVal

proc bestMove*(game: Game, depth: int): Move =
  ## Generate a MoveTree of a `game` with a given `depth`, run Minimax and return
  ## the best evaluated move.
  var moves = game.genLegalMoves(game.toMove)
  var bestMove: Move
  var bestEval: int
  if game.toMove == Color.White:
    bestEval = LoVal
  else:
    bestEval = HiVal
  for move in moves:
    var tmpGame = game
    tmpGame.checkedMove(move)
    var tmpEval = tmpGame.evaluate()
    if game.toMove == Color.White:
      if tmpEval > bestEval:
        bestEval = tmpEval
        bestMove = move
    else:
      if tmpEval < bestEval:
        bestEval = tmpEval
        bestMove = move
  return bestMove


