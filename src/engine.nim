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
  CheckmateVal = -1000  ## `CheckmateVal` is the engines value for a checkmate.
  DrawVal = 0           ## `DrawVal` is the engines value for a draw.
  LoVal = -1000000      ## `LoVal` is a value always lower than  any evaluation.

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
  var evaluation: int
  if game.isCheckmate(game.toMove):
    evaluation = ord(game.toMove) * CheckmateVal
  if game.isStalemate(game.toMove):
    evaluation = DrawVal
  else:
    evaluation = game.pieceEval()
    if game.isDrawClaimable():
      if game.toMove == Color.White:
        evaluation = max(DrawVal, evaluation)
      else:
        evaluation = min(DrawVal, evaluation)
  return evaluation

proc spanMoveTree*(game: Game, depth: int): MoveTree =
  ## Create and return a Movetree of a given `game` with a given maximum `depth`.
  var mTree: MoveTree
  mTree.game = game
  if depth != 0 and not game.isCheckmate(game.toMove) and not game.isStalemate(game.toMove):
    let possibleMoves = game.genLegalMoves(game.toMove)
    for move in possibleMoves:
      var tmpGame = game
      tmpGame.checkedMove(move)
      mTree.children.add(spanMoveTree(tmpGame, depth-1))
  return mTree

proc negaMax*(mTree: MoveTree): int =
  ## Return the value of the root node of a given `MoveTree`
  if mTree.children == []:
    return mTree.game.evaluate()
  var bestVal = LoVal
  for child in mTree.children:
    var tmpVal = -negaMax(child)
    bestVal = max(bestVal, tmpVal)
  return bestVal

proc bestMove*(game: Game, depth: int): Move =
  ## Generate a MoveTree of a `game` with a given `depth`, run negaMax and return
  ## the best evaluated move.
  var moves = game.genLegalMoves(game.toMove)
  var bestMove: Move
  var bestEval: int
  bestEval = LoVal
  for move in moves:
    var tmpGame = game
    tmpGame.checkedMove(move)
    var tmpMTree = tmpGame.spanMoveTree(depth)
    var tmpEval = -tmpMTree.negaMax()
    echo("move:", moveToNotation(move),"; eval:", tmpEval)
    if tmpEval > bestEval:
      bestEval = tmpEval
      bestMove = move
  return bestMove
