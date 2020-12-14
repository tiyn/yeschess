import tables
from strutils import parseInt

type
  Color* = enum
    Black = -1, White = 1
  ## Board that saves the pieces
  Pieces* = array[0..119, int]
  ## Board that checks if pieces moved
  Moved* = array[0..119, bool]
  ## Game as object of different values
  Game* = object
    pieces*: Pieces
    moved: Moved
    toMove*: Color
  ## Move as object
  Move* = object
    start: int
    dest: int
    color: Color
    prom: int

const
  # IDs for piece
  BlockID* = 999
  PawnID* = 1
  KnightID* = 2
  BishopID* = 3
  RookID* = 4
  QueenID* = 5
  KingID* = 6
  EnPassantID* = 7
  # IDs that are saved in the array
  Block* = BlockID
  WPawn* = PawnID
  WKnight* = KnightID
  WBishop* = BishopID
  WRook* = RookID
  WQueen* = QueenID
  WKing* = KingID
  WEnPassant* = EnPassantID
  BPawn* = -PawnID
  BKnight* = -KnightID
  BBishop* = -BishopID
  BRook* = -RookID
  BQueen* = -QueenID
  BKing* = -KingID
  BEnPassant* = EnPassantID
  # Directions of movement
  N = 10
  S = -N
  W = 1
  E = -W
  # Movement options for pieces (Bishop/Rook/Queen can repeat in the same direction)
  Knight_Moves = [N+N+E, N+N+W, E+E+N, E+E+S, S+S+E, S+S+W, W+W+N, W+W+S]
  Bishop_Moves = [N+E, N+W, S+E, S+W]
  Rook_Moves = [N, E, S, W]
  Queen_Moves = [N, E, S, W, N+E, N+W, S+E, S+W]
  King_Moves = [N, E, S, W, N+E, N+W, S+E, S+W]
  King_Moves_White_Castle = [E+E, W+W]
  Pawn_Moves_White = [N]
  Pawn_Moves_White_Double = [N+N]
  Pawn_Moves_White_Attack = [N+E, N+W]

var PieceChar = {
  0: " ",
  1: "P",
  2: "N",
  3: "B",
  4: "R",
  5: "Q",
  6: "K",
  7: " ",
  -1: "p",
  -2: "n",
  -3: "b",
  -4: "r",
  -5: "q",
  -6: "k",
  -7: " ",
  999: "-"
}.newTable

var FileChar = {
  "a": 7,
  "b": 6,
  "c": 5,
  "d": 4,
  "e": 3,
  "f": 2,
  "g": 1,
  "h": 0
}.newTable

proc getField*(pieces: Pieces, field: int): int =
  return pieces[field]

proc setField(pieces: var Pieces, field: int, val: int): bool {.discardable.} =
  if (val in PieceChar):
    try:
      pieces[field] = val
      return true
    except Exception:
      return false

proc getField*(moved: Moved, field: int): bool =
  return moved[field]

proc setField(moved: var Moved, field: int, val: bool): bool {.discardable.} =
  try:
    moved[field] = val
    return true
  except Exception:
    return false

proc initBoard(): Pieces =
  ## Create and return a board with pieces in starting position.
  let board = [
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block,
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block,
    Block, WRook, WKnight, WBishop, WKing, WQueen, WBishop, WKnight, WRook, Block,
    Block, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, WPawn, Block,
    Block, 0, 0, 0, 0, 0, 0, 0, 0, Block,
    Block, 0, 0, 0, 0, 0, 0, 0, 0, Block,
    Block, 0, 0, 0, 0, 0, 0, 0, 0, Block,
    Block, 0, 0, 0, 0, 0, 0, 0, 0, Block,
    Block, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, BPawn, Block,
    Block, BRook, BKnight, BBishop, BKing, BQueen, BBishop, BKnight, BRook, Block,
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block,
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block]
  return board

proc initBoard(pieces: array[0..63, int]): Pieces =
  ## Create and return a board with pieces in position of choice
  let board = [
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block,
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block,
    Block, pieces[0], pieces[1], pieces[2], pieces[3], pieces[4], pieces[5],
        pieces[6], pieces[7], Block,
    Block, pieces[8], pieces[9], pieces[10], pieces[11], pieces[12], pieces[13],
        pieces[14], pieces[15], Block,
    Block, pieces[16], pieces[17], pieces[18], pieces[19], pieces[20], pieces[
        21], pieces[22], pieces[23], Block,
    Block, pieces[24], pieces[25], pieces[26], pieces[27], pieces[28], pieces[
        29], pieces[30], pieces[31], Block,
    Block, pieces[32], pieces[33], pieces[34], pieces[35], pieces[36], pieces[
        37], pieces[38], pieces[39], Block,
    Block, pieces[40], pieces[41], pieces[42], pieces[43], pieces[44], pieces[
        45], pieces[46], pieces[47], Block,
    Block, pieces[48], pieces[49], pieces[50], pieces[51], pieces[52], pieces[
        53], pieces[54], pieces[55], Block,
    Block, pieces[56], pieces[57], pieces[58], pieces[59], pieces[60], pieces[
        61], pieces[62], pieces[63], Block,
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block,
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block]
  return board

proc initMoved(): Moved =
  ## Create and return a board of pieces moved.
  var moved: Moved
  return moved

proc initGame*(): Game =
  ## Create and return a Game object.
  let game = Game(pieces: initBoard(), moved: initMoved(),
      to_move: Color.White)
  return game

proc initGame*(pieces: array[0..63, int], color: Color): Game =
  ## Create ad return a Game object based on a position of choice.
  let pieces = initBoard(pieces)
  let compare = initBoard()
  var moved = initMoved()
  var same_piece: bool
  for ind in pieces.low..pieces.high:
    same_piece = (pieces[ind] != compare[ind])
    moved.setField(ind, same_piece)
  let game = Game(pieces: pieces, moved: moved,
      to_move: color)
  return game

proc getMove*(start: int, dest: int, prom: int, color: Color): Move =
  ## Get a move object from `start` to `dest` with an eventual promition to `prom`
  var move = Move(start: start, dest: dest, prom: prom * ord(color), color: color)
  if (KnightID > prom or QueenID < prom):
    move.prom = QueenID
  return move

proc getMove*(start: int, dest: int, color: Color): Move =
  ## Get a move object from `start` to `dest` with automatic promition to `queen`
  var move = Move(start: start, dest: dest, prom: QueenID * ord(color), color: color)
  return move

proc echoBoard*(game: Game, color: Color) =
  ## Prints out the given `board` with its pieces as characters and line indices from perspecive of `color`.
  var line_str = ""
  if (color == Color.Black):
    for i in countup(0, len(game.pieces)-1):
      if (game.pieces.getField(i) == 999):
        continue
      line_str &= PieceChar[game.pieces[i]] & " "
      if ((i+2) %% 10 == 0):
        line_str &= $((int)((i)/10)-1) & "\n"
    echo line_str
    echo "h g f e d c b a"
  else:
    for i in countdown(len(game.pieces)-1, 0):
      if (game.pieces.getField(i) == 999):
        continue
      line_str &= PieceChar[game.pieces[i]] & " "
      if ((i-1) %% 10 == 0):
        line_str &= $((int)((i)/10)-1) & "\n"
    echo line_str
    echo "a b c d e f g h"

proc fieldToInd*(file: string, line: int): int =
  ## Calculate board index from `file` and `line` of a chess board.
  try:
    return 1+(line+1)*10+FileChar[file]
  except IndexDefect, ValueError:
    return -1

proc fieldToInd*(field: string): int =
  ## Calculate board index from `field` of a chess board.
  try:
    return fieldToInd($field[0], parseInt($field[1]))
  except IndexDefect, ValueError:
    return -1

proc indToField*(ind: int): string =
  ## Calculate field name from board index `ind`.
  let line = (int)ind/10-1
  let file_ind = (ind)%%10-1
  for file, i in FileChar:
    if FileChar[file] == file_ind:
      return $file & $line

proc notationToMove*(notation: string, color: Color): Move =
  ## Convert simplified algebraic chess `notation` to a move object, color of player is `color`.
  try:
    var move: Move
    var start = fieldToInd(notation[0..1])
    var dest = fieldToInd(notation[2..3])
    move = getMove(start, dest, color)
    if (len(notation) > 4):
      var promStr = $notation[4]
      var prom: int
      case promStr:
        of "Q":
          prom = QueenID * ord(color)
        of "R":
          prom = RookID * ord(color)
        of "B":
          prom = BishopID * ord(color)
        of "N":
          prom = KnightID * ord(color)
      move = getMove(start, dest, prom, color)
    return move
  except IndexError:
    var move: Move
    return move

proc genBishopDests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a bishop with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in Bishop_Moves:
      dest = field+move
      target = game.pieces.getField(dest)
      while (target != 999 and (ord(color) * target <= 0) or target ==
          EnPassantID or target == -EnPassantID):
        res.add(dest)
        if (ord(color) * target < 0 and ord(color) * target > -EnPassantID):
          break
        dest = dest+move
        target = game.pieces.getField(dest)
    return res
  except IndexDefect:
    return @[]

proc genRookDests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a rook with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in Rook_Moves:
      dest = field+move
      target = game.pieces.getField(dest)
      while (target != 999 and (ord(color) * target <= 0) or target ==
          EnPassantID or target == -EnPassantID):
        res.add(dest)
        if (ord(color) * target < 0 and ord(color) * target > -EnPassantID):
          break
        dest = dest+move
        target = game.pieces.getField(dest)
    return res
  except IndexDefect:
    return @[]

proc genQueenDests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a queen with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in Queen_Moves:
      dest = field+move
      target = game.pieces.getField(dest)
      while (target != 999 and (ord(color) * target <= 0) or target ==
          EnPassantID or target == -EnPassantID):
        res.add(dest)
        if (ord(color) * target < 0 and ord(color) * target > -EnPassantID):
          break
        dest = dest+move
        target = game.pieces.getField(dest)
    return res
  except IndexDefect:
    return @[]

proc genKingCastleDest(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible castle destinations for a king with specific `color` located at index `field` of `game`
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    var half_dest: int
    var half_target: int
    for castle in King_Moves_White_Castle:
      dest = field + castle
      target = game.pieces.getField(dest)
      half_dest = field + (int)castle/2
      half_target = game.pieces.getField(half_dest)
      if (target == 999 or (target != 0)):
        continue
      if (half_target == 999 or (half_target != 0)):
        continue
      res.add(dest)
    return res
  except IndexDefect:
    return @[]


proc genKingDests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a king with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in King_Moves:
      dest = field + move
      target = game.pieces.getField(dest)
      if (target == 999 or (ord(color) * target > 0 and ord(color) * target != EnPassantID)):
        continue
      res.add(dest)
    res.add(game.genKingCastleDest(field, color))
    return res
  except IndexDefect:
    return @[]

proc genKnightDests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a knight with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in Knight_Moves:
      dest = field + move
      target = game.pieces.getField(dest)
      if (target == 999 or (ord(color) * target > 0 and ord(color) * target != EnPassantID)):
        continue
      res.add(dest)
    return res
  except IndexDefect:
    return @[]

proc genPawnAttackDests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible attack destinations for a pawn with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for attacks in Pawn_Moves_White_Attack:
      dest = field + (attacks * ord(color))
      target = game.pieces.getField(dest)
      if (target == 999 or ord(color) * target >= 0):
        continue
      res.add(dest)
    return res
  except IndexDefect:
    return @[]

proc genPawnDoubleDests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible double destinations for a pawn with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for doubles in Pawn_Moves_White_Double:
      dest = field + doubles * ord(color)
      target = game.pieces.getField(dest)
      if (game.moved.getField(field) or (target != 0) or (
          game.pieces.getField(dest+(S*ord(color))) != 0)):
        continue
      res.add(dest)
    return res
  except IndexDefect:
    return @[]

proc genPawnDests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a pawn with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in Pawn_Moves_White:
      dest = field + move * ord(color)
      target = game.pieces.getField(dest)
      if (target != 0 and target != ord(color) * EnPassantID):
        continue
      res.add(dest)
    res.add(game.genPawnAttackDests(field, color))
    res.add(game.genPawnDoubleDests(field, color))
    return res
  except IndexDefect:
    return @[]

proc pieceOn(game: Game, color: Color, sequence: seq[int],
    pieceID: int): bool =
  ## Check if a piece with `pieceID` of a given `color` is in a field described in a `sequence` in a `game`.
  for check in sequence:
    if game.pieces.getField(check) == ord(color) * -1 * pieceID:
      return true
  return false

proc isAttacked(game: Game, position: int, color: Color): bool =
  ## Check if a field is attacked by the opposite of `color` in a `game`.
  var attacked = false
  attacked = attacked or game.pieceOn(color, game.genPawnAttackDests(
      position, color), PawnID)
  attacked = attacked or game.pieceOn(color, game.genQueenDests(position,
      color), QueenID)
  attacked = attacked or game.pieceOn(color, game.genKingDests(position,
      color), KingID)
  attacked = attacked or game.pieceOn(color, game.genRookDests(position,
      color), RookID)
  attacked = attacked or game.pieceOn(color, game.genBishopDests(position,
      color), BishopID)
  attacked = attacked or game.pieceOn(color, game.genKnightDests(position,
      color), KnightID)
  return attacked

proc isInCheck*(game: Game, color: Color): bool =
  ## Check if the King of a given `color` is in check in a `game`.
  var king_pos: int
  for i in countup(0, game.pieces.high):
    if game.pieces.getField(i) == ord(color) * KingID:
      king_pos = i
  return game.isAttacked(king_pos, color)

proc uncheckedMove(game: var Game, start: int, dest: int): bool {.discardable.} =
  ## Moves a piece if possible from `start` position to `dest` position.
  ## Doesnt check boundaries, checks, movement.
  ## returns true if the piece moved, else false
  try:
    let piece = game.pieces.getField(start)
    if game.pieces.setField(start, 0):
      if game.pieces.setField(dest, piece):
        game.moved.setField(start, true)
        game.moved.setField(dest, true)
        return true
      else:
        game.pieces.setField(start, piece)
  except IndexDefect, ValueError:
    return false

proc moveLeadsToCheck(game: Game, start: int, dest: int,
    color: Color): bool =
  ## Checks in a `game` if a move from `start` to `dest` puts the `color` king in check.
  var check = game
  check.uncheckedMove(start, dest)
  return check.isInCheck(color)

proc removeEnPassant(pieces: var Pieces, color: Color): void =
  ## Removes every en passant of given `color` from the `game`.
  for field in pieces.low..pieces.high:
    if pieces.getField(field) == ord(color) * EnPassantID:
      pieces.setField(field, 0)

proc genLegalKnightMoves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal knight moves starting from `field` in a `game` for a `color`.
  if game.pieces.getField(field) != KnightID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.genKnightDests(field, color)
  for dest in moves:
    if not game.moveLeadsToCheck(field, dest, color):
      res.add(getMove(field, dest, color))
  return res

proc genLegalBishopMoves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal bishop moves starting from `field` in a `game` for a `color`.
  if game.pieces.getField(field) != BishopID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.genBishopDests(field, color)
  for dest in moves:
    if not game.moveLeadsToCheck(field, dest, color):
      res.add(getMove(field, dest, color))
  return res

proc genLegalRookMoves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal rook moves starting from `field` in a `game` for a `color`.
  if game.pieces.getField(field) != RookID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.genRookDests(field, color)
  for dest in moves:
    if not game.moveLeadsToCheck(field, dest, color):
      res.add(getMove(field, dest, color))
  return res

proc genLegalQueenMoves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal queen moves starting from `field` in a `game` for a `color`.
  if game.pieces.getField(field) != QueenID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.genQueenDests(field, color)
  for dest in moves:
    if not game.moveLeadsToCheck(field, dest, color):
      res.add(getMove(field, dest, color))
  return res

proc genLegalKingMoves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal king moves starting from `field` in a `game` for a `color`.
  if game.pieces.getField(field) != KingID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.genKingDests(field, color)
  for dest in moves:
    if field - dest == W+W and game.isAttacked(dest+W, color):
      continue
    if field - dest == E+E and game.isAttacked(dest+E, color):
      continue
    if not game.moveLeadsToCheck(field, dest, color):
      res.add(getMove(field, dest, color))
  return res

proc genPawnPromotion(move: Move, color: Color): seq[Move] =
  ## Generate all possible promotions of a `move` by `color`.
  var promotions = newSeq[Move]()
  let start = move.start
  let dest = move.dest
  if (90 < dest and dest < 99) or (20 < dest and dest < 29):
    for piece in KnightID..QueenID:
      promotions.add(getMove(start, dest, piece, color))
  return promotions

proc genLegalPawnMoves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal pawn moves starting from `field` in a `game` for a `color`.
  if game.pieces.getField(field) != PawnID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.genPawnDests(field, color)
  for dest in moves:
    if not game.moveLeadsToCheck(field, dest, color):
      var promotions = genPawnPromotion(getMove(field, dest, color), color)
      if promotions != @[]:
        res.add(promotions)
      else:
        res.add(getMove(field, dest, color))
  return res

proc genLegalMoves*(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal moves starting from `field` in a `game` for a `color`.
  var legal_moves = newSeq[Move]()
  var target = ord(color) * game.pieces.getField(field)
  if 0 < target and target < EnPassantID:
    legal_moves = case target:
      of PawnID:
        game.genLegalPawnMoves(field, color)
      of KnightID:
        game.genLegalKnightMoves(field, color)
      of BishopID:
        game.genLegalBishopMoves(field, color)
      of RookID:
        game.genLegalRookMoves(field, color)
      of QueenID:
        game.genLegalQueenMoves(field, color)
      of KingID:
        game.genLegalKingMoves(field, color)
      else:
        @[]
  return legal_moves

proc genLegalMoves*(game: Game, color: Color): seq[Move] =
  ## Generates all legal moves in a `game` for a `color`.
  var legal_moves = newSeq[Move]()
  for field in game.pieces.low..game.pieces.high:
    legal_moves.add(game.genLegalMoves(field, color))
  return legal_moves

proc castling(game: var Game, kstart: int, dest_kingside: bool,
    color: Color): bool {.discardable.} =
  ## Tries to castle in a given `game` with the king of a given `color` from `start`.
  ## `dest_kingside` for kingside castling, else castling is queenside.
  ## This process checks for the legality of the move and performs the switch of `game.to_move`
  try:
    if game.toMove != color:
      return false
    var kdest = kstart
    var rstart: int
    var rdest: int
    if (dest_kingside):
      kdest = kstart + (E+E)
      rstart = kstart + (E+E+E)
      rdest = rstart + (W+W)
    else:
      rstart = kstart + (W+W+W+W)
      rdest = rstart + (E+E+E)
      kdest = kstart + (W+W)
    if not game.moved.getField(kstart) and not game.moved.getField(rstart):
      var check = false
      if (dest_kingside):
        check = check or game.isAttacked(kstart, color)
        check = check or game.isAttacked(kstart+(E), color)
        check = check or game.isAttacked(kstart+(E+E), color)
      else:
        check = check or game.isAttacked(kstart, color)
        check = check or game.isAttacked(kstart+(W), color)
        check = check or game.isAttacked(kstart+(W+W), color)
      if check:
        return false
      game.uncheckedMove(kstart, kdest)
      game.uncheckedMove(rstart, rdest)
      game.toMove = Color(ord(game.toMove)*(-1))
      return true
    return false
  except IndexDefect, ValueError:
    return false

proc checkedMove*(game: var Game, move: Move): bool {.discardable.} =
  ## Tries to make a move in a given `game` with the piece of a given `color` from `start` to `dest`.
  ## This process checks for the legality of the move and performs the switch of `game.to_move`
  try:
    let start = move.start
    let dest = move.dest
    let color = move.color
    let prom = move.prom
    if game.toMove != color:
      return false
    var sequence = newSeq[Move]()
    let piece = game.pieces.getField(start)
    var create_en_passant = false
    var captured_en_passant = false
    var move: Move
    move = getMove(start, dest, color)
    if (piece == PawnID * ord(color)):
      create_en_passant = dest in game.genPawnDoubleDests(start, color)
      captured_en_passant = (game.pieces.getField(dest) == -1 * ord(color) * EnPassantID)
    sequence.add(game.genLegalMoves(start, color))
    if (move in sequence):
      game.pieces.removeEnPassant(color)
      if (piece == KingID * ord(color) and (start - dest == (W+W))):
        return game.castling(start, true, color)
      elif (piece == KingID * ord(color) and (start - dest == (E+E))):
        return game.castling(start, false, color)
      else:
        game.uncheckedMove(start, dest)
      game.toMove = Color(ord(game.toMove)*(-1))
      if create_en_passant:
        game.pieces.setField(dest-(N*ord(color)), EnPassantID * ord(color))
      if captured_en_passant:
        game.pieces.setField(dest-(N*ord(color)), 0)
      if ((90 < dest and dest < 99) or (20 < dest and dest < 29)) and
          game.pieces.getField(dest) == PawnID * ord(color):
        game.pieces.setField(dest, prom)
      return true
  except IndexDefect, ValueError:
    return false

proc hasNoMoves(game: Game, color: Color): bool =
  ## Checks if a player of a given `color` has no legal moves in a `game`.
  return (game.genLegalMoves(color) == @[])

proc isCheckmate*(game: Game, color: Color): bool =
  ## Checks if a player of a given `color` in a `game` is checkmate.
  return game.hasNoMoves(color) and game.isInCheck(color)

proc isStalemate*(game: Game, color: Color): bool =
  ## Checks if a player of a given `color` in a `game` is stalemate.
  return game.hasNoMoves(color) and not game.isInCheck(color)
