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
    to_move*: Color
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

proc init_board(): Pieces =
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

proc get_move*(start: int, dest: int, prom: int, color: Color): Move =
  ## Get a move object from `start` to `dest` with an eventual promition to `prom`
  var move = Move(start: start, dest: dest, prom: prom * ord(color), color: color)
  if (KnightID > prom or QueenID < prom):
    move.prom = QueenID
  return move

proc get_move*(start: int, dest: int, color: Color): Move =
  ## Get a move object from `start` to `dest` with automatic promition to `queen`
  var move = Move(start: start, dest: dest, prom: QueenID * ord(color), color: color)
  return move

proc init_moved(): Moved =
  ## Create and return a board of pieces moved.
  var moved: Moved
  return moved

proc init_game*(): Game =
  ## Create and return a Game object.
  let game = Game(pieces: init_board(), moved: init_moved(),
      to_move: Color.White)
  return game

proc get_field(pieces: Pieces, field: int): int =
  return pieces[field]

proc set_field(pieces: var Pieces, field: int, val: int): bool {.discardable.} =
  if (val in PieceChar):
    try:
      pieces[field] = val
      return true
    except Exception:
      return false

proc get_field(moved: Moved, field: int): bool =
  return moved[field]

proc set_field(moved: var Moved, field: int, val: bool): bool {.discardable.} =
  try:
    moved[field] = val
    return true
  except Exception:
    return false

proc echo_board*(game: Game, color: Color) =
  ## Prints out the given `board` with its pieces as characters and line indices from perspecive of `color`.
  var line_str = ""
  if (color == Color.Black):
    for i in countup(0, len(game.pieces)-1):
      if (game.pieces.get_field(i) == 999):
        continue
      line_str &= PieceChar[game.pieces[i]] & " "
      if ((i+2) %% 10 == 0):
        line_str &= $((int)((i)/10)-1) & "\n"
    echo line_str
    echo "h g f e d c b a"
  else:
    for i in countdown(len(game.pieces)-1, 0):
      if (game.pieces.get_field(i) == 999):
        continue
      line_str &= PieceChar[game.pieces[i]] & " "
      if ((i-1) %% 10 == 0):
        line_str &= $((int)((i)/10)-1) & "\n"
    echo line_str
    echo "a b c d e f g h"

proc field_to_ind*(file: string, line: int): int =
  ## Calculate board index from `file` and `line` of a chess board.
  try:
    return 1+(line+1)*10+FileChar[file]
  except IndexDefect, ValueError:
    return -1

proc field_to_ind*(field: string): int =
  ## Calculate board index from `field` of a chess board.
  try:
    return field_to_ind($field[0], parseInt($field[1]))
  except IndexDefect, ValueError:
    return -1

proc ind_to_field*(ind: int): string =
  ## Calculate field name from board index `ind`.
  let line = (int)ind/10-1
  let file_ind = (ind)%%10-1
  for file, i in FileChar:
    if FileChar[file] == file_ind:
      return $file & $line

proc gen_bishop_dests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a bishop with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in Bishop_Moves:
      dest = field+move
      target = game.pieces.get_field(dest)
      while (target != 999 and (ord(color) * target <= 0) or target == EnPassantID):
        res.add(dest)
        if (ord(color) * target < 0 and ord(color) * target > -EnPassantID):
          break
        dest = dest+move
        target = game.pieces.get_field(dest)
    return res
  except IndexDefect:
    return @[]

proc gen_rook_dests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a rook with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in Rook_Moves:
      dest = field+move
      target = game.pieces.get_field(dest)
      while (target != 999 and (ord(color) * target <= 0) or target == EnPassantID):
        res.add(dest)
        if (ord(color) * target < 0 and ord(color) * target > -EnPassantID):
          break
        dest = dest+move
        target = game.pieces.get_field(dest)
    return res
  except IndexDefect:
    return @[]

proc gen_queen_dests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a queen with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in Queen_Moves:
      dest = field+move
      target = game.pieces.get_field(dest)
      while (target != 999 and (ord(color) * target <= 0) or target == EnPassantID):
        res.add(dest)
        if (ord(color) * target < 0 and ord(color) * target > -EnPassantID):
          break
        dest = dest+move
        target = game.pieces.get_field(dest)
    return res
  except IndexDefect:
    return @[]

proc gen_king_castle_dest(game: Game, field: int, color: Color): seq[int] =
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
      target = game.pieces.get_field(dest)
      half_dest = field + (int)castle/2
      half_target = game.pieces.get_field(half_dest)
      if (target == 999 or (target != 0)):
        continue
      if (half_target == 999 or (half_target != 0)):
        continue
      res.add(dest)
    return res
  except IndexDefect:
    return @[]


proc gen_king_dests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a king with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in King_Moves:
      dest = field + move
      target = game.pieces.get_field(dest)
      if (target == 999 or (ord(color) * target > 0 and ord(color) * target != EnPassantID)):
        continue
      res.add(dest)
    res.add(game.gen_king_castle_dest(field, color))
    return res
  except IndexDefect:
    return @[]

proc gen_knight_dests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a knight with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in Knight_Moves:
      dest = field + move
      target = game.pieces.get_field(dest)
      if (target == 999 or (ord(color) * target > 0 and ord(color) * target != EnPassantID)):
        continue
      res.add(dest)
    return res
  except IndexDefect:
    return @[]

proc gen_pawn_attack_dests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible attack destinations for a pawn with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for attacks in Pawn_Moves_White_Attack:
      dest = field + attacks * ord(color)
      target = game.pieces.get_field(dest)
      if (target == 999 or ord(color) * target >= 0):
        continue
      res.add(dest)
    return res
  except IndexDefect:
    return @[]

proc gen_pawn_double_dests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible double destinations for a pawn with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for doubles in Pawn_Moves_White_Double:
      dest = field + doubles * ord(color)
      target = game.pieces.get_field(dest)
      if (game.moved.get_field(field) or (target != 0) or (
          game.pieces.get_field(dest+(S*ord(color))) != 0)):
        continue
      res.add(dest)
    return res
  except IndexDefect:
    return @[]

proc gen_pawn_dests(game: Game, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a pawn with specific `color` located at index `field` of `game`.
  ## Returns a sequence of possible indices to move to.
  try:
    var res = newSeq[int]()
    var dest: int
    var target: int
    for move in Pawn_Moves_White:
      dest = field + move * ord(color)
      target = game.pieces.get_field(dest)
      if (target != 0 and target != ord(color) * EnPassantID):
        continue
      res.add(dest)
    res.add(game.gen_pawn_attack_dests(field, color))
    res.add(game.gen_pawn_double_dests(field, color))
    return res
  except IndexDefect:
    return @[]

proc piece_on(game: Game, color: Color, sequence: seq[int],
    pieceID: int): bool =
  ## Check if a piece with `pieceID` of a given `color` is in a field described in a `sequence` in a `game`.
  for check in sequence:
    if game.pieces.get_field(check) == ord(color) * -1 * pieceID:
      return true
  return false

proc is_attacked(game: Game, position: int, color: Color): bool =
  ## Check if a field is attacked by the opposite of `color` in a `game`.
  var attacked = false
  attacked = attacked or game.piece_on(color, game.gen_pawn_attack_dests(
      position, color), PawnID)
  attacked = attacked or game.piece_on(color, game.gen_queen_dests(position,
      color), QueenID)
  attacked = attacked or game.piece_on(color, game.gen_king_dests(position,
      color), KingID)
  attacked = attacked or game.piece_on(color, game.gen_rook_dests(position,
      color), RookID)
  attacked = attacked or game.piece_on(color, game.gen_bishop_dests(position,
      color), BishopID)
  attacked = attacked or game.piece_on(color, game.gen_knight_dests(position,
      color), KnightID)
  return attacked

proc is_in_check*(game: Game, color: Color): bool =
  ## Check if the King of a given `color` is in check in a `game`.
  var king_pos: int
  for i in countup(0, game.pieces.high):
    if game.pieces.get_field(i) == ord(color) * KingID:
      king_pos = i
  return game.is_attacked(king_pos, color)

proc unchecked_move(game: var Game, start: int, dest: int): bool {.discardable.} =
  ## Moves a piece if possible from `start` position to `dest` position.
  ## Doesnt check boundaries, checks, movement.
  ## returns true if the piece moved, else false
  try:
    let piece = game.pieces.get_field(start)
    if game.pieces.set_field(start, 0):
      if game.pieces.set_field(dest, piece):
        game.moved.set_field(start, true)
        game.moved.set_field(dest, true)
        return true
      else:
        game.pieces.set_field(start, piece)
  except IndexDefect, ValueError:
    return false

proc move_leads_to_check(game: Game, start: int, dest: int,
    color: Color): bool =
  ## Checks in a `game` if a move from `start` to `dest` puts the `color` king in check.
  var check = game
  check.unchecked_move(start, dest)
  return check.is_in_check(color)

proc remove_en_passant(pieces: var Pieces, color: Color): void =
  ## Removes every en passant of given `color` from the `game`.
  for field in pieces.low..pieces.high:
    if pieces.get_field(field) == ord(color) * EnPassantID:
      pieces.set_field(field, 0)

proc gen_legal_knight_moves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal knight moves starting from `field` in a `game` for a `color`.
  if game.pieces.get_field(field) != KnightID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.gen_knight_dests(field, color)
  for dest in moves:
    if not game.move_leads_to_check(field, dest, color):
      res.add(get_move(field, dest, color))
  return res

proc gen_legal_bishop_moves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal bishop moves starting from `field` in a `game` for a `color`.
  if game.pieces.get_field(field) != BishopID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.gen_bishop_dests(field, color)
  for dest in moves:
    if not game.move_leads_to_check(field, dest, color):
      res.add(get_move(field, dest, color))
  return res

proc gen_legal_rook_moves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal rook moves starting from `field` in a `game` for a `color`.
  if game.pieces.get_field(field) != RookID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.gen_rook_dests(field, color)
  for dest in moves:
    if not game.move_leads_to_check(field, dest, color):
      res.add(get_move(field, dest, color))
  return res

proc gen_legal_queen_moves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal queen moves starting from `field` in a `game` for a `color`.
  if game.pieces.get_field(field) != QueenID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.gen_queen_dests(field, color)
  for dest in moves:
    if not game.move_leads_to_check(field, dest, color):
      res.add(get_move(field, dest, color))
  return res

proc gen_legal_king_moves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal king moves starting from `field` in a `game` for a `color`.
  if game.pieces.get_field(field) != KingID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.gen_king_dests(field, color)
  for dest in moves:
    if field - dest == W+W and game.is_attacked(dest+W, color):
      continue
    if field - dest == E+E and game.is_attacked(dest+E, color):
      continue
    if not game.move_leads_to_check(field, dest, color):
      res.add(get_move(field, dest, color))
  return res

proc gen_pawn_promotion(move: Move, color: Color): seq[Move] =
  ## Generate all possible promotions of a `move` by `color`.
  var promotions = newSeq[Move]()
  let start = move.start
  let dest = move.dest
  if (90 < dest and dest < 99) or (20 < dest and dest < 29):
    for piece in KnightID..QueenID:
      promotions.add(get_move(start, dest, piece, color))
  return promotions

proc gen_legal_pawn_moves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal pawn moves starting from `field` in a `game` for a `color`.
  if game.pieces.get_field(field) != PawnID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.gen_pawn_dests(field, color)
  for dest in moves:
    if not game.move_leads_to_check(field, dest, color):
      var promotions = gen_pawn_promotion(get_move(field, dest, color), color)
      if promotions != @[]:
        res.add(promotions)
      else:
        res.add(get_move(field, dest, color))
  return res

proc gen_legal_moves*(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal moves starting from `field` in a `game` for a `color`.
  var legal_moves = newSeq[Move]()
  var target = ord(color) * game.pieces.get_field(field)
  if 0 < target and target < EnPassantID:
    legal_moves = case target:
      of PawnID:
        game.gen_legal_pawn_moves(field, color)
      of KnightID:
        game.gen_legal_knight_moves(field, color)
      of BishopID:
        game.gen_legal_bishop_moves(field, color)
      of RookID:
        game.gen_legal_rook_moves(field, color)
      of QueenID:
        game.gen_legal_queen_moves(field, color)
      of KingID:
        game.gen_legal_king_moves(field, color)
      else:
        @[]
  return legal_moves

proc gen_legal_moves*(game: Game, color: Color): seq[Move] =
  ## Generates all legal moves in a `game` for a `color`.
  var legal_moves = newSeq[Move]()
  for field in game.pieces.low..game.pieces.high:
    legal_moves.add(game.gen_legal_moves(field, color))
  return legal_moves

proc castling(game: var Game, kstart: int, dest_kingside: bool,
    color: Color): bool {.discardable.} =
  ## Tries to castle in a given `game` with the king of a given `color` from `start`.
  ## `dest_kingside` for kingside castling, else castling is queenside.
  ## This process checks for the legality of the move and performs the switch of `game.to_move`
  try:
    if game.to_move != color:
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
    if not game.moved.get_field(kstart) and not game.moved.get_field(rstart):
      var check = false
      if (dest_kingside):
        check = check or game.is_attacked(kstart, color)
        check = check or game.is_attacked(kstart+(E), color)
        check = check or game.is_attacked(kstart+(E+E), color)
      else:
        check = check or game.is_attacked(kstart, color)
        check = check or game.is_attacked(kstart+(W), color)
        check = check or game.is_attacked(kstart+(W+W), color)
      if check:
        return false
      game.unchecked_move(kstart, kdest)
      game.unchecked_move(rstart, rdest)
      return true
    return false
  except IndexDefect, ValueError:
    return false

proc checked_move*(game: var Game, move: Move): bool {.discardable.} =
  ## Tries to make a move in a given `game` with the piece of a given `color` from `start` to `dest`.
  ## This process checks for the legality of the move and performs the switch of `game.to_move`
  try:
    let start = move.start
    let dest = move.dest
    let color = move.color
    let prom = move.prom
    if game.to_move != color:
      return false
    var sequence = newSeq[Move]()
    let piece = game.pieces.get_field(start)
    var create_en_passant = false
    var captured_en_passant = false
    var move: Move
    move = get_move(start, dest, color)
    if (piece == PawnID * ord(color)):
      create_en_passant = dest in game.gen_pawn_double_dests(start, color)
      captured_en_passant = (game.pieces.get_field(dest) == -1 * ord(color) * EnPassantID)
    sequence.add(game.gen_legal_moves(start, color))
    if (move in sequence):
      game.pieces.remove_en_passant(color)
      if (piece == KingID * ord(color) and (start - dest == (W+W))):
        game.castling(start, true, color)
      elif (piece == KingID * ord(color) and (start - dest == (E+E))):
        game.castling(start, false, color)
      else:
        game.unchecked_move(start, dest)
      game.to_move = Color(ord(game.to_move)*(-1))
      if create_en_passant:
        game.pieces.set_field(dest-(N*ord(color)), EnPassantID * ord(color))
      if captured_en_passant:
        game.pieces.set_field(dest-(N*ord(color)), 0)
      if ((90 < dest and dest < 99) or (20 < dest and dest < 29)) and
          game.pieces.get_field(dest) == PawnID * ord(color):
        game.pieces.set_field(dest, prom)
      return true
  except IndexDefect, ValueError:
    return false

proc has_no_moves(game: Game, color: Color): bool =
  ## Checks if a player of a given `color` has no legal moves in a `game`.
  return (game.gen_legal_moves(color) == @[])

proc is_checkmate*(game: Game, color: Color): bool =
  ## Checks if a player of a given `color` in a `game` is checkmate.
  return game.has_no_moves(color) and game.is_in_check(color)

proc is_stalemate*(game: Game, color: Color): bool =
  ## Checks if a player of a given `color` in a `game` is stalemate.
  return game.has_no_moves(color) and not game.is_in_check(color)
