import tables
from strutils import parseInt

type
  Color* = enum
    Black = -1, White = 1
  ## Board that saves the board
  Board* = array[0..119, int]
  ## Board that checks if pieces moved
  Moved* = array[0..119, bool]
  ## Game as object of different values
  Game* = object
    board*: Board
    moved: Moved
    toMove*: Color
  ## Move as object
  Move* = object
    start: int
    dest: int
    color: Color
    prom: int
  ## Amount of pieces
  Pieces = tuple
    p: int
    k: int
    b: int
    r: int
    q: int

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

let PieceChar = {
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

let FileChar = {
  "a": 7,
  "b": 6,
  "c": 5,
  "d": 4,
  "e": 3,
  "f": 2,
  "g": 1,
  "h": 0
}.newTable

const InsufficientMaterial = @[
  #p, n, b, r, q
    # lone kings
  (0, 0, 0, 0, 0),
  # knight only
  (0, 0, 1, 0, 0),
  # bishop only
  (0, 1, 0, 0, 0),
  # 2 knights
  (0, 2, 0, 0, 0)
  ]

proc getField*(board: Board, field: int): int =
  return board[field]

proc setField(board: var Board, field: int, val: int): bool {.discardable.} =
  if (val in PieceChar):
    try:
      board[field] = val
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

proc checkInsufficientMaterial(board: Board): bool =
  ## Checks for combinations of pieces on a `board`, where no checkmate can be forced
  var wp = 0
  var wn = 0
  var wb = 0
  var wr = 0
  var wq = 0
  var bp = 0
  var bn = 0
  var bb = 0
  var br = 0
  var bq = 0
  for field in board.low..board.high:
    case board.getField(field):
      of WPawn:
        wp = wp + 1
      of BPawn:
        bp = bp + 1
      of WKnight:
        wn = wn + 1
      of BKnight:
        bn = bn + 1
      of WBishop:
        wb = wb + 1
      of BBishop:
        bb = bb + 1
      of WRook:
        wr = wr + 1
      of BRook:
        br = br + 1
      of WQueen:
        wq = wq + 1
      of BQueen:
        bq = bq + 1
      else:
        continue
  let wpieces = (wp, wn, wb, wr, wq)
  let bpieces = (bp, bn, bb, br, bq)
  return (wpieces in InsufficientMaterial) and (bpieces in InsufficientMaterial)

proc initBoard(): Board =
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

proc initBoard(board: array[0..63, int]): Board =
  ## Create and return a board with pieces in position of choice
  let board = [
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block,
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block,
    Block, board[0], board[1], board[2], board[3], board[4], board[5],
        board[6], board[7], Block,
    Block, board[8], board[9], board[10], board[11], board[12], board[13],
        board[14], board[15], Block,
    Block, board[16], board[17], board[18], board[19], board[20], board[
        21], board[22], board[23], Block,
    Block, board[24], board[25], board[26], board[27], board[28], board[
        29], board[30], board[31], Block,
    Block, board[32], board[33], board[34], board[35], board[36], board[
        37], board[38], board[39], Block,
    Block, board[40], board[41], board[42], board[43], board[44], board[
        45], board[46], board[47], Block,
    Block, board[48], board[49], board[50], board[51], board[52], board[
        53], board[54], board[55], Block,
    Block, board[56], board[57], board[58], board[59], board[60], board[
        61], board[62], board[63], Block,
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block,
    Block, Block, Block, Block, Block, Block, Block, Block, Block, Block]
  return board

proc initMoved(): Moved =
  ## Create and return a board of pieces moved.
  var moved: Moved
  return moved

proc initGame*(): Game =
  ## Create and return a Game object.
  let game = Game(board: initBoard(), moved: initMoved(),
      to_move: Color.White)
  return game

proc initGame*(board: array[0..63, int], color: Color): Game =
  ## Create ad return a Game object based on a position of choice.
  let board = initBoard(board)
  let compare = initBoard()
  var moved = initMoved()
  var same_piece: bool
  for ind in board.low..board.high:
    same_piece = (board[ind] != compare[ind])
    moved.setField(ind, same_piece)
  let game = Game(board: board, moved: moved,
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
    for i in countup(0, len(game.board)-1):
      if (game.board.getField(i) == 999):
        continue
      line_str &= PieceChar[game.board[i]] & " "
      if ((i+2) %% 10 == 0):
        line_str &= $((int)((i)/10)-1) & "\n"
    echo line_str
    echo "h g f e d c b a"
  else:
    for i in countdown(len(game.board)-1, 0):
      if (game.board.getField(i) == 999):
        continue
      line_str &= PieceChar[game.board[i]] & " "
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
      target = game.board.getField(dest)
      while (target != 999 and (ord(color) * target <= 0) or target ==
          EnPassantID or target == -EnPassantID):
        res.add(dest)
        if (ord(color) * target < 0 and ord(color) * target > -EnPassantID):
          break
        dest = dest+move
        target = game.board.getField(dest)
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
      target = game.board.getField(dest)
      while (target != 999 and (ord(color) * target <= 0) or target ==
          EnPassantID or target == -EnPassantID):
        res.add(dest)
        if (ord(color) * target < 0 and ord(color) * target > -EnPassantID):
          break
        dest = dest+move
        target = game.board.getField(dest)
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
      target = game.board.getField(dest)
      while (target != 999 and (ord(color) * target <= 0) or target ==
          EnPassantID or target == -EnPassantID):
        res.add(dest)
        if (ord(color) * target < 0 and ord(color) * target > -EnPassantID):
          break
        dest = dest+move
        target = game.board.getField(dest)
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
      target = game.board.getField(dest)
      half_dest = field + (int)castle/2
      half_target = game.board.getField(half_dest)
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
      target = game.board.getField(dest)
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
      target = game.board.getField(dest)
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
      target = game.board.getField(dest)
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
      target = game.board.getField(dest)
      if (game.moved.getField(field) or (target != 0) or (
          game.board.getField(dest+(S*ord(color))) != 0)):
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
      target = game.board.getField(dest)
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
    if game.board.getField(check) == ord(color) * -1 * pieceID:
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
  for i in countup(0, game.board.high):
    if game.board.getField(i) == ord(color) * KingID:
      king_pos = i
  return game.isAttacked(king_pos, color)

proc uncheckedMove(game: var Game, start: int, dest: int): bool {.discardable.} =
  ## Moves a piece if possible from `start` position to `dest` position.
  ## Doesnt check boundaries, checks, movement.
  ## returns true if the piece moved, else false
  try:
    let piece = game.board.getField(start)
    if game.board.setField(start, 0):
      if game.board.setField(dest, piece):
        game.moved.setField(start, true)
        game.moved.setField(dest, true)
        return true
      else:
        game.board.setField(start, piece)
  except IndexDefect, ValueError:
    return false

proc moveLeadsToCheck(game: Game, start: int, dest: int,
    color: Color): bool =
  ## Checks in a `game` if a move from `start` to `dest` puts the `color` king in check.
  var check = game
  check.uncheckedMove(start, dest)
  return check.isInCheck(color)

proc removeEnPassant(board: var Board, color: Color): void =
  ## Removes every en passant of given `color` from the `game`.
  for field in board.low..board.high:
    if board.getField(field) == ord(color) * EnPassantID:
      board.setField(field, 0)

proc genLegalKnightMoves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal knight moves starting from `field` in a `game` for a `color`.
  if game.board.getField(field) != KnightID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.genKnightDests(field, color)
  for dest in moves:
    if not game.moveLeadsToCheck(field, dest, color):
      res.add(getMove(field, dest, color))
  return res

proc genLegalBishopMoves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal bishop moves starting from `field` in a `game` for a `color`.
  if game.board.getField(field) != BishopID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.genBishopDests(field, color)
  for dest in moves:
    if not game.moveLeadsToCheck(field, dest, color):
      res.add(getMove(field, dest, color))
  return res

proc genLegalRookMoves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal rook moves starting from `field` in a `game` for a `color`.
  if game.board.getField(field) != RookID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.genRookDests(field, color)
  for dest in moves:
    if not game.moveLeadsToCheck(field, dest, color):
      res.add(getMove(field, dest, color))
  return res

proc genLegalQueenMoves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal queen moves starting from `field` in a `game` for a `color`.
  if game.board.getField(field) != QueenID * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = game.genQueenDests(field, color)
  for dest in moves:
    if not game.moveLeadsToCheck(field, dest, color):
      res.add(getMove(field, dest, color))
  return res

proc genLegalKingMoves(game: Game, field: int, color: Color): seq[Move] =
  ## Generates all legal king moves starting from `field` in a `game` for a `color`.
  if game.board.getField(field) != KingID * ord(color):
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
  if game.board.getField(field) != PawnID * ord(color):
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
  var target = ord(color) * game.board.getField(field)
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
  for field in game.board.low..game.board.high:
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
    let piece = game.board.getField(start)
    var create_en_passant = false
    var captured_en_passant = false
    var move: Move
    move = getMove(start, dest, color)
    if (piece == PawnID * ord(color)):
      create_en_passant = dest in game.genPawnDoubleDests(start, color)
      captured_en_passant = (game.board.getField(dest) == -1 * ord(color) * EnPassantID)
    sequence.add(game.genLegalMoves(start, color))
    if (move in sequence):
      game.board.removeEnPassant(color)
      if (piece == KingID * ord(color) and (start - dest == (W+W))):
        return game.castling(start, true, color)
      elif (piece == KingID * ord(color) and (start - dest == (E+E))):
        return game.castling(start, false, color)
      else:
        game.uncheckedMove(start, dest)
      game.toMove = Color(ord(game.toMove)*(-1))
      if create_en_passant:
        game.board.setField(dest-(N*ord(color)), EnPassantID * ord(color))
      if captured_en_passant:
        game.board.setField(dest-(N*ord(color)), 0)
      if ((90 < dest and dest < 99) or (20 < dest and dest < 29)) and
          game.board.getField(dest) == PawnID * ord(color):
        game.board.setField(dest, prom)
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
  return (game.hasNoMoves(color) and not game.isInCheck(color)) or
      game.board.checkInsufficientMaterial()
