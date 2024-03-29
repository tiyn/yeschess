import algorithm
import sequtils
import strutils
import sugar
import tables

type
  Color* = enum
    ## `Color` describes the possible color of players.
    Black = -1,
    White = 1
  Board = array[120, int] ## \
    ## `Board` saves the position of the chess pieces.
  CastleRights = tuple
    ## `CastleRights` contains the rights to castling for each player.
    wk: bool # `wk` describes White kingside castle
    wq: bool # `wq` describes White queenside castle
    bk: bool # `bk` describes Black kingside castle
    bq: bool # `bq` describes Black queenside castle
  Chess* = object
    ## `Chess` stores all important information of a chess chess.
    board*: Board
    toMove*: Color
    previousBoard: seq[Board]
    halfMoveClock: int
    fullMoveCounter*: int
    castleRights: CastleRights
    enPassantSquare: int
  Move* = object
    ## `Move` stores all important information for a move.
    start: int
    dest: int
    color: Color
    prom: int
  PieceAmount = tuple
    ## `PieceAmount` describes the number of pieces of a certain type a/both
    ## player/s  has/have.
    p: int # `p` describes the amount of pawns.
    n: int # `n` describes the amount of knights.
    b: int # `b` describes the amount of bishops.
    r: int # `r` describes the amount of rooks.
    q: int # `q` describes the amount of queens.
  Pieces = array[10, int]

const
  Block = 999                                           ## \
    ## `Block` is the value assigned to empty blocked fields in a board.
  Empty = 0                                             ## \
    ## `Empty` is the value assigned to empty fields on a board.
  WPawn* = 1
    ## `WPawn` is the value assigned to a square in a board with a white pawn.
  WKnight* = 2                                          ## \
    ## `WKnight` is the value assigned to a square in a board with a white
    ## knight.
  WBishop* = 3                                          ## \
    ## `WBishop` is the value assigned to a square in a board with a white
    ## bishop.
  WRook* = 4                                            ## \
    ## `WRook` is the value assigned to a square in a board with a white rook.
  WQueen* = 5                                           ## \
    ## `WQueen` is the value assigned to a square in a board with a white
    ## queen.
  WKing* = 6                                            ## \
    ## `WKing` is the value assigned to a square in a board with a white king.
  BPawn* = -WPawn                                       ## \
    ## `BPawn` is the value assigned to a square in a board with a black pawn.
  BKnight* = -WKnight                                   ## \
    ## `BKnight` is the value assigned to a square in a board with a black\
    ## knight.
  BBishop* = -WBishop                                   ## \
    ## `BBishop` is the value assigned to a square in a board with a black\
    ## bishop.
  BRook* = -WRook                                       ## \
    ## `BRook` is the value assigned to a square in a board with a black rook.
  BQueen* = -WQueen                                     ## \
    ## `BQueen` is the value assigned to a square in a board with a black queen.
  BKing* = -WKing                                       ## \
    ## `BKing` is the value assigned to a square in a board with a black king.
  N = 10 ## `N` describes a move a field up the board from whites perspective.
  S = -N ## `S` describes a move a field down the board from whites perspective.
  W = 1 ## `W` describes a move a field to the left from whites perspective.
  E = -W ## `E` describes a move a field to the right from whites perspective.
  # Directions for the pieces. Special moves are in separate arrays.
  Knight_Moves = @[N+N+E, N+N+W, E+E+N, E+E+S, S+S+E, S+S+W, W+W+N, W+W+S] ## \
    ## `Knight_Moves` describes the possible knight moves.
  Bishop_Moves = @[N+E, N+W, S+E, S+W]                  ## \
    ## `Bishop_Moves` describes the possible 1 field distance bishop moves.
  Rook_Moves = @[N, E, S, W]                            ## \
    ## `Rook_Moves` describes the possible 1 field distance rook moves.
  Queen_Moves = @[N, E, S, W, N+E, N+W, S+E, S+W]       ## \
    ## `Queen_Moves` describes the possible 1 field distance queen moves.
  King_Moves = @[N, E, S, W, N+E, N+W, S+E, S+W]        ## \
    ## `King_Moves` describes the possible 1 field distance king moves.
  King_Moves_White_Castle = @[E+E, W+W]                 ## \
    ## `King_Moves` describes the possible king moves for castling.
  Pawn_Moves_White = @[N]                               ## \
    ## `Pawn_Moves_White` describes the possible 1 field distance pawn moves
    ## from whites perspective that are not attacks.
  Pawn_Moves_White_Double = @[N+N]                      ## \
    ## `Pawn_Moves_White_Double` describes the possible pawn 2 field distance
    ## moves from whites perspective.
  Pawn_Moves_White_Attack = @[N+E, N+W]                 ## \
    ## `Pawn_Moves_White` describes the possible 1 field distance pawn moves
    ## from whites perspective that are ttacks.
  InsufficientMaterial: array[4, PieceAmount] = [
    (0, 0, 0, 0, 0),                                    # only kings
    (0, 0, 1, 0, 0),                                    # bishop only
    (0, 1, 0, 0, 0),                                    # knight only
    (0, 2, 0, 0, 0)                                     # 2 knights
  ] ## `InsufficientMaterial` describes the pieces where no checkmate can be
                                                        ## forced

let
  PieceChar = {
    0: " ",
    WPawn: "P",
    WKnight: "N",
    WBishop: "B",
    WRook: "R",
    WQueen: "Q",
    WKing: "K",
    BPawn: "p",
    BKnight: "n",
    BBishop: "b",
    BRook: "r",
    BQueen: "q",
    BKing: "k",
  }.newTable ## \
    ## `PieceChar` describes the representation for the pieceIDs for the cli.
  FileChar = {
    "a": 0,
    "b": 1,
    "c": 2,
    "d": 3,
    "e": 4,
    "f": 5,
    "g": 6,
    "h": 7,
  }.newTable ## \
  # `FileChar` maps the files of the chessboard to numbers for better
  # conversion.

proc fieldToInd(field: string): int =
  ## Calculate and return board index from `field` of a chess board.
  ## Returns -1 if the `field` was not input correct.
  try:
    var file = $field[0]
    var line = parseInt($field[1])
    return 1 + (line + 1) * 10 + (7 - FileChar[file])
  except IndexDefect, ValueError:
    return -1

proc indToField(ind: int): string =
  ## Calculate and returns field name from board index `ind`.
  let line = int(ind / 10 - 1)
  let file_ind = 7 - (ind %% 10 - 1)
  for file, i in FileChar:
    if FileChar[file] == file_ind:
      return $file & $line

proc getMove(start: int, dest: int, prom: int, color: Color): Move =
  ## Get a move object of the `color` player from `start` to `dest` with an
  ## eventual promition to `prom`.
  var move = Move(start: start, dest: dest, prom: prom * ord(color), color: color)
  if prom < WKnight or prom > WQueen:
    move.prom = WQueen
  return move

proc getMove(start: int, dest: int, color: Color): Move =
  ## Get a move object of the `color` player from `start` to `dest` with
  ## automatic promition to queen.
  var move = Move(start: start, dest: dest, prom: WQueen * ord(color), color: color)
  return move

proc notationToMove*(notation: string, color: Color): Move =
  ## Convert and return simplified algebraic chess `notation` to a move object,
  ## color of player is `color`.
  var move: Move
  if notation.len < 4:
    return getMove(-1, -1, -1, color)
  var start = fieldToInd(notation[0..1])
  var dest = fieldToInd(notation[2..3])
  move = getMove(start, dest, color)
  if notation.len > 4:
    var promStr = $notation[4]
    let prom = case promStr:
      of "R":
        WRook
      of "B":
        WBishop
      of "N":
        WKnight
      else:
        WQueen
    move = getMove(start, dest, prom, color)
  return move

proc moveToNotation*(move: Move, board: Board): string =
  ## Convert and return a `move` object to simplified algebraic chess notation.
  var res: string
  var start = indToField(move.start)
  res.add(start)
  var dest = indToField(move.dest)
  res.add(dest)
  var color = move.color
  var prom = PieceChar[move.prom]
  if abs(board[move.start]) == WPawn and ((color == Color.White and dest[1] ==
      '8') or (color == Color.Black and dest[1] == '1')):
    res.add(prom)
  return res

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

proc initBoard(board: array[64, int]): Board =
  ## Create and return a board with pieces in position of choice, described in
  ## `board`.
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

proc initChess*(): Chess =
  ## Create and return a Chess object.
  let chess = Chess(board: initBoard(),
      to_move: Color.White, castleRights: (true, true, true, true), fullMoveCounter: 1, enPassantSquare: -1)
  return chess

proc initChess*(fen: string): Chess =
  ## Create and return a Chess object from `fen`.
  var revPieceChar = toSeq(PieceChar.pairs).map(y => (y[1], y[0])).toTable
  var fenArr = fen.split(" ")
  var squares: array[64, int]
  var squaresInd: int
  for i, subc in fenArr[0].reversed():
    if subc == '/':
      continue
    if subc.isDigit():
      for j in 1..parseInt($subc):
        squares[squaresInd] = revPieceChar[" "]
        squaresInd += 1
        continue
    else:
      squares[squaresInd] = revPieceChar[$subc]
      squaresInd += 1
  var board = initBoard(squares)
  var toMove: Color
  if fenArr[1] == "w":
    toMove = Color.White
  else:
    toMove = Color.Black
  var castleRights: CastleRights
  if fenArr[2].contains("K"):
    castleRights.wk = true
  if fenArr[2].contains("Q"):
    castleRights.wq = true
  if fenArr[2].contains("k"):
    castleRights.bk = true
  if fenArr[2].contains("q"):
    castleRights.bq = true
  var enPassantSquare = -1
  if fenArr[3] != "-":
    enPassantSquare = fieldToInd(fenArr[3])
  let halfMoveClock = parseInt(fenArr[4])
  let fullMoveCounter = parseInt(fenArr[5])
  return Chess(board: board, toMove: toMove, castleRights: castleRights,
    halfMoveClock: halfMoveClock, fullMoveCounter: fullMoveCounter, enPassantSquare: enPassantSquare)

proc convertToFen*(chess: Chess): string =
  ## Build and return a fen string from a given `chess` object.
  var pieces: string
  var fen: string
  var spaceOcc: int
  var fileCounter = 0
  for i, piece in chess.board.reversed:
    if not (piece == Block):
      if fileCounter == 8:
        if spaceOcc != 0:
          pieces &= $spaceOcc
          spaceOcc = 0
        pieces &= "/"
        fileCounter = 0
      if PieceChar[piece] == " ":
        spaceOcc += 1
      else:
        if spaceOcc != 0:
          pieces &= $spaceOcc
          spaceOcc = 0
        pieces &= PieceChar[piece]
      fileCounter += 1
    if i == chess.board.reversed.high and spaceOcc > 0:
      pieces &= $spaceOcc
  fen &= pieces & " "
  if chess.toMove == Color.White:
    fen &= "w "
  else:
    fen &= "b "
  var castleR: string
  if chess.castleRights.wk:
    castleR &= "K"
  if chess.castleRights.wq:
    castleR &= "Q"
  if chess.castleRights.bk:
    castleR &= "k"
  if chess.castleRights.bq:
    castleR &= "q"
  if castleR.isEmptyOrWhitespace:
    castleR = "-"
  fen &= castleR & " "
  if chess.enPassantSquare != -1:
    fen &= indToField(chess.enPassantSquare) & " "
  else:
    fen &= "- "
  fen &= $chess.halfMoveClock & " " & $chess.fullMoveCounter
  return fen


proc echoBoard*(chess: Chess, color: Color) =
  ## Prints out the given `board` with its pieces as characters and line
  ## indices from perspecive of `color`.
  var line_str: string
  if color == Color.Black:
    for i in 0..chess.board.len-1:
      if chess.board[i] == Block:
        continue
      line_str &= PieceChar[chess.board[i]] & " "
      if (i + 2) %% 10 == 0:
        line_str &= $int((i / 10) - 1) & "\n"
    echo line_str
    echo "h g f e d c b a"
  else:
    for i in countdown(len(chess.board) - 1, 0):
      if chess.board[i] == Block:
        continue
      line_str &= PieceChar[chess.board[i]] & " "
      if (i - 1) %% 10 == 0:
        line_str &= $int((i / 10) - 1) & "\n"
    echo line_str
    echo "a b c d e f g h"

proc genPawnAttackDests(chess: Chess, field: int, color: Color): seq[int] =
  ## Generate possible attack destinations for a pawn with specific `color`
  ## located at index `field` of `chess`.
  ## Returns a sequence of possible indices to move to.
  if field < chess.board.low or field > chess.board.high:
    return @[]
  var res = newSeq[int]()
  var dest: int
  var target: int
  for attacks in Pawn_Moves_White_Attack:
    dest = field + (attacks * ord(color))
    if dest == chess.enPassantSquare:
      res.add(dest)
    if not dest in chess.board.low..chess.board.high:
      continue
    target = chess.board[dest]
    if target == Block or ord(color) * target >= 0:
      continue
    res.add(dest)
  return res

proc genPawnDoubleDests(chess: Chess, field: int, color: Color): seq[int] =
  ## Generate possible double destinations for a pawn with specific `color`
  ## located at index `field` of `chess`.
  ## Returns a sequence of possible indices to move to.
  if field < chess.board.low or field > chess.board.high:
    return @[]
  var res = newSeq[int]()
  var dest: int
  var target: int
  for doubles in Pawn_Moves_White_Double:
    dest = field + doubles * ord(color)
    target = chess.board[dest]
    if target != 0 or
        chess.board[dest + (S * ord(color))] != 0:
      continue
    if color == Color.White and not (field in fieldToInd("h2")..fieldToInd("a2")):
      continue
    if color == Color.Black and not (field in fieldToInd("h7")..fieldToInd("a7")):
      continue
    res.add(dest)
  return res

proc genPawnDests(chess: Chess, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a pawn with specific `color` located at
  ## index `field` of `chess`.
  ## Returns a sequence of possible indices to move to.
  if field < chess.board.low or field > chess.board.high:
    return @[]
  var res = newSeq[int]()
  var dest: int
  var target: int
  for move in Pawn_Moves_White:
    dest = field + move * ord(color)
    if not dest in chess.board.low..chess.board.high:
      continue
    target = chess.board[dest]
    if target != 0 and dest != chess.enPassantSquare:
      continue
    res.add(dest)
  res.add(chess.genPawnAttackDests(field, color))
  res.add(chess.genPawnDoubleDests(field, color))
  return res

proc genKnightDests(chess: Chess, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a knight with specific `color` located
  ## at index `field` of `chess`.
  ## Returns a sequence of possible indices to move to.
  if field < chess.board.low or field > chess.board.high:
    return @[]
  var res = newSeq[int]()
  var dest: int
  var target: int
  for move in Knight_Moves:
    dest = field + move
    if not dest in chess.board.low..chess.board.high:
      continue
    target = chess.board[dest]
    if target == Block or ord(color) * target > 0:
      continue
    res.add(dest)
  return res

proc genSlidePieceDests(chess: Chess, field: int, color: Color, moves: seq[
    int]): seq[int] =
  ## Generate possible destinations for a piece with `moves` and specific `color`
  ## located at index `field` of `chess`.
  ## Returns a sequence of possible indices to move to.
  if field < chess.board.low or field > chess.board.high:
    return @[]
  var res = newSeq[int]()
  var dest: int
  var target: int
  for move in moves:
    dest = field + move
    if not dest in chess.board.low..chess.board.high:
      continue
    target = chess.board[dest]
    while target != Block and ord(color) * target <= 0:
      res.add(dest)
      if ord(color) * target < 0:
        break
      dest = dest + move
      target = chess.board[dest]
  return res

proc genBishopDests(chess: Chess, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a bishop with specific `color` located
  ## at index `field` of `chess`.
  ## Returns a sequence of possible indices to move to.
  return genSlidePieceDests(chess, field, color, Bishop_Moves)

proc genRookDests(chess: Chess, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a rook with specific `color` located at
  ## index `field` of `chess`.
  ## Returns a sequence of possible indices to move to.
  return genSlidePieceDests(chess, field, color, Rook_Moves)

proc genQueenDests(chess: Chess, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a queen with specific `color` located
  ## at index `field` of `chess`.
  ## Returns a sequence of possible indices to move to.
  return genSlidePieceDests(chess, field, color, Queen_Moves)

proc genKingCastleDest(chess: Chess, field: int, color: Color): seq[int] =
  ## Generate possible castle destinations for a king with specific `color`
  ## located at index `field` of `chess`
  ## Returns a sequence of possible indices to move to.
  if field < chess.board.low or field > chess.board.high:
    return @[]
  var res = newSeq[int]()
  var dest: int
  var target: int
  var half_dest: int
  var half_target: int
  for castle in King_Moves_White_Castle:
    dest = field + castle
    if not dest in chess.board.low..chess.board.high:
      continue
    target = chess.board[dest]
    half_dest = field + int(castle / 2)
    half_target = chess.board[half_dest]
    if target == Block or target != 0:
      continue
    if half_target == Block or half_target != 0:
      continue
    res.add(dest)
  return res

proc genKingDests(chess: Chess, field: int, color: Color): seq[int] =
  ## Generate possible destinations for a king with specific `color`
  ## located at index `field` of `chess`.
  ## Returns a sequence of possible indices to move to.
  if field < chess.board.low or field > chess.board.high:
    return @[]
  var res = newSeq[int]()
  var dest: int
  var target: int
  for move in King_Moves:
    dest = field + move
    if not dest in chess.board.low..chess.board.high:
      continue
    target = chess.board[dest]
    if target == Block or ord(color) * target > 0:
      continue
    res.add(dest)
  res.add(chess.genKingCastleDest(field, color))
  return res

proc pieceOn(chess: Chess, color: Color, sequence: seq[int],
    pieceID: int): bool =
  ## Returns true if the `PieceID` of a given `color` is in `sequence` else
  ## wrong.
  for check in sequence:
    if chess.board[check] == ord(color) * -pieceID:
      return true
  return false

proc isAttacked(chess: Chess, position: int, color: Color): bool =
  ## Returns true if a `position` in a `chess` is attacked by the opposite
  ## color of `color`.
  var attacked = false
  attacked = attacked or chess.pieceOn(color, chess.genPawnAttackDests(
      position, color), WPawn)
  attacked = attacked or chess.pieceOn(color, chess.genQueenDests(position,
      color), WQueen)
  attacked = attacked or chess.pieceOn(color, chess.genKingDests(position,
      color), WKing)
  attacked = attacked or chess.pieceOn(color, chess.genRookDests(position,
      color), WRook)
  attacked = attacked or chess.pieceOn(color, chess.genBishopDests(position,
      color), WBishop)
  attacked = attacked or chess.pieceOn(color, chess.genKnightDests(position,
      color), WKnight)
  return attacked

proc isInCheck(chess: Chess, color: Color): bool =
  ## Returns true if the king of a given `color` is in check in a `chess`.
  var king_pos: int
  for i in 0..chess.board.high:
    if chess.board[i] == ord(color) * WKing:
      king_pos = i
  return chess.isAttacked(king_pos, color)

proc uncheckedMove(chess: var Chess, start: int, dest: int): bool {.discardable.} =
  ## Moves a piece if possible from `start` position to `dest` position in a
  ## `chess`.
  let piece = chess.board[start]
  chess.board[start] = 0
  chess.board[dest] = piece
  if start == fieldToInd("e1"):
    chess.castleRights.wk = false
    chess.castleRights.wq = false
  elif start == fieldToInd("h1"):
    chess.castleRights.wk = false
  elif start == fieldToInd("a1"):
    chess.castleRights.wq = false
  elif start == fieldToInd("e8"):
    chess.castleRights.bk = false
    chess.castleRights.bq = false
  elif start == fieldToInd("h8"):
    chess.castleRights.bk = false
  elif start == fieldToInd("a8"):
    chess.castleRights.bq = false
  return true

proc moveLeadsToCheck(chess: Chess, start: int, dest: int,
    color: Color): bool =
  ## Returns true if a move from `start` to `dest` in a `chess` puts the `color`
  ## king in check.
  var check = chess
  check.uncheckedMove(start, dest)
  return check.isInCheck(color)

proc genPawnPromotion(board: Board, move: Move, color: Color): seq[Move] =
  ## Generate all possible promotions on a `board` of a `move` by `color`.
  var promotions = newSeq[Move]()
  let start = move.start
  let dest = move.dest
  if board[start] != WPawn * ord(color):
    return @[]
  if (fieldToInd("h8") <= dest and fieldToInd("a8") >= dest and color == Color.White) or
    (fieldToInd("h1") <= dest and fieldToInd("a1") >= dest and color == Color.Black):
    for piece in WKnight..WQueen:
      promotions.add(getMove(start, dest, piece, color))
  return promotions

proc genLegalMovesStd(chess: Chess, field: int, color: Color, piece: int,
  moves: seq[int]): seq[Move] =
  ## Generates all legal knight moves in a `chess` starting from `field` for a
  ## `color`.
  if chess.board[field] != piece * ord(color):
    return @[]
  var res = newSeq[Move]()
  for dest in moves:
    if not chess.moveLeadsToCheck(field, dest, color):
      res.add(getMove(field, dest, color))
  return res

proc genLegalPawnMoves(chess: Chess, field: int, color: Color): seq[Move] =
  ## Generates all legal pawn moves in a `chess` starting from `field` for a
  ## `color`.
  if chess.board[field] != WPawn * ord(color):
    return @[]
  var res = newSeq[Move]()
  var moves = chess.genPawnDests(field, color)
  for dest in moves:
    if not chess.moveLeadsToCheck(field, dest, color):
      var promotions = chess.board.genPawnPromotion(getMove(field, dest, color), color)
      if promotions != @[]:
        res.add(promotions)
      else:
        res.add(getMove(field, dest, color))
  return res

proc genLegalKnightMoves(chess: Chess, field: int, color: Color): seq[Move] =
  ## Generates all legal knight moves in a `chess` starting from `field` for a
  ## `color`.
  return genLegalMovesStd(chess, field, color, WKnight, chess.genKnightDests(
      field, color))

proc genLegalBishopMoves(chess: Chess, field: int, color: Color): seq[Move] =
  ## Generates all legal bishop moves in a `chess` starting from `field` for a
  ## `color`.
  return genLegalMovesStd(chess, field, color, WBishop, chess.genBishopDests(
      field, color))

proc genLegalRookMoves(chess: Chess, field: int, color: Color): seq[Move] =
  ## Generates all legal rook moves in a `chess` starting from `field` for a
  ## `color`.
  return genLegalMovesStd(chess, field, color, WRook, chess.genRookDests(
      field, color))

proc genLegalQueenMoves(chess: Chess, field: int, color: Color): seq[Move] =
  ## Generates all legal queen moves in a `chess` starting from `field` for a
  ## `color`.
  return genLegalMovesStd(chess, field, color, WQueen, chess.genQueenDests(
      field, color))

proc genLegalKingMoves(chess: Chess, field: int, color: Color): seq[Move] =
  ## Generates all legal king moves in a `chess` starting from `field` for a
  ## `color`.
  return genLegalMovesStd(chess, field, color, WKing, chess.genKingDests(
      field, color))

proc genLegalMoves(chess: Chess, field: int, color: Color): seq[Move] =
  ## Generates all legal moves in a `chess` starting from `field` for a `color`.
  var legal_moves = newSeq[Move]()
  var target = abs(chess.board[field])
  if WPawn <= target and target <= WKing:
    legal_moves = case target:
      of WPawn:
        chess.genLegalPawnMoves(field, color)
      of WKnight:
        chess.genLegalKnightMoves(field, color)
      of WBishop:
        chess.genLegalBishopMoves(field, color)
      of WRook:
        chess.genLegalRookMoves(field, color)
      of WQueen:
        chess.genLegalQueenMoves(field, color)
      of WKing:
        chess.genLegalKingMoves(field, color)
      else:
        @[]
  return legal_moves

proc genLegalMoves*(chess: Chess, color: Color): seq[Move] =
  ## Generates all legal moves in a `chess` for a `color`.
  var legal_moves = newSeq[Move]()
  for field in chess.board.low..chess.board.high:
    legal_moves.add(chess.genLegalMoves(field, color))
  return legal_moves

proc castling(chess: var Chess, kstart: int, dest_kingside: bool,
    color: Color): bool {.discardable.} =
  ## Tries to castle in a given `chess` with the king of a given `color` from
  ## `kstart`.
  ## `dest_kingside` for kingside castling, else castling is queenside.
  ## This process checks for the legality of the move and performs the switch
  ## of `chess.to_move`
  if chess.toMove != color:
    return false
  var kdest: int
  var rstart: int
  var rdest: int
  var rights: bool
  if dest_kingside:
    kdest = kstart + E + E
    rstart = kstart + E + E + E
    rdest = rstart + W + W
    if color == Color.White:
      rights = chess.castleRights.wk
    else:
      rights = chess.castleRights.bk
  else:
    kdest = kstart + W + W
    rstart = kstart + W + W + W + W
    rdest = rstart + E + E + E
    if color == Color.White:
      rights = chess.castleRights.wq
    else:
      rights = chess.castleRights.bq
  if rights:
    if dest_kingside:
      if chess.isAttacked(kstart, color) or chess.isAttacked(kstart+E, color) or
        chess.isAttacked(kstart+E+E, color) or chess.board[kstart+E] != 0 or
        chess.board[kstart+E+E] != 0:
        return false
    else:
      if chess.isAttacked(kstart, color) or chess.isAttacked(kstart+W, color) or
        chess.isAttacked(kstart+W+W, color) or chess.board[kstart+W] != 0 or
        chess.board[kstart+W+W] != 0 or chess.board[kstart+W+W+W] != 0:
        return false
    chess.uncheckedMove(kstart, kdest)
    chess.uncheckedMove(rstart, rdest)
    chess.previousBoard = @[chess.board]
    chess.toMove = Color(ord(chess.toMove) * (-1))
    chess.enPassantSquare = -1
    return true
  return false

proc checkedMove*(chess: var Chess, move: Move): bool {.discardable.} =
  ## Tries to make a `move` in a given `chess``.
  ## This process checks for the legality of the move and performs the switch
  ## of `chess.to_move` with exception of castling (castling() switches).
  let start = move.start
  let dest = move.dest
  let color = move.color
  let prom = move.prom
  if chess.toMove != color or start == -1 or dest == -1:
    return false
  let piece = chess.board[start]
  var createEnPassant: bool
  var capturedEnPassant: bool
  var fiftyMoveRuleReset: bool
  var move: Move
  move = getMove(start, dest, color)
  if piece == WKing * ord(color) and start - dest == (W+W):
    return chess.castling(start, true, color)
  elif piece == WKing * ord(color) and start - dest == (E+E):
    return chess.castling(start, false, color)
  if piece == WPawn * ord(color):
    createEnPassant = dest in chess.genPawnDoubleDests(start, color)
    capturedEnPassant = (dest == chess.enPassantSquare)
    fiftyMoveRuleReset = true
  if chess.board[move.dest] != 0:
    fiftyMoveRuleReset = true
  if move in chess.genLegalMoves(start, color):
    chess.enPassantSquare = -1
    chess.uncheckedMove(start, dest)
    chess.toMove = Color(ord(chess.toMove)*(-1))
    if capturedEnPassant:
      chess.board[dest - (N * ord(color))] = 0
    if ((fieldToInd("h8") <= dest and dest <= fieldToInd("a8")) or
      (fieldToInd("h1") <= dest and dest <= fieldToInd("a1"))) and
      piece == WPawn * ord(color):
      chess.board[dest] = prom
    chess.previousBoard.add(chess.board)
    chess.halfMoveClock = chess.halfMoveClock + 1
    if color == Color.Black:
      chess.fullMoveCounter += 1
    if fiftyMoveRuleReset:
      chess.halfMoveClock = 0
      chess.previousBoard = @[chess.board]
    if createEnPassant and (chess.board[dest + E] == BPawn * ord(color) or
        chess.board[dest + W] == BPawn * ord(color)):
        chess.enPassantSquare = dest - (N * ord(color))
        chess.previousBoard = @[]
    return true

proc isCheckmate*(chess: Chess, color: Color): bool =
  ## Returns true if the `color` player is checkmate in a `chess`.
  return chess.genLegalMoves(color) == @[] and chess.isInCheck(color)

proc threeMoveRep(chess: Chess): bool =
  ## Returns true if a 3-fold repitition happened on the last move of the
  ## `chess`.
  if chess.previousBoard == @[]:
    return false
  var lastState = chess.previousBoard[chess.previousBoard.high]
  var reps: int
  for stateInd in chess.previousBoard.low..chess.previousBoard.high:
    if chess.previousBoard[stateInd] == lastState:
      reps = reps + 1
  return reps >= 3

proc isDrawClaimable*(chess: Chess): bool =
  ## Returns true if a draw is claimable by the current player.
  return chess.threeMoveRep() or chess.halfMoveClock >= 100

proc checkInsufficientMaterial(board: Board): bool =
  ## Checks for combinations of pieces on a `board`, where no checkmate can be
  ## forced.
  ## Returns true if no player can force a checkmate to the other.
  var pieces: Pieces
  for field in board.low..board.high:
    var piece = board[field]
    var index: int
    if piece >= WPawn and piece <= WRook:
      index = piece - WPawn # map lowest value to 0
      pieces[index] += 1
    elif piece <= BPawn and piece >= BRook:
      index = WRook - piece # map black pieces after whites
      pieces[index] += 1
  let wpieces: PieceAmount = (pieces[0], pieces[1], pieces[2], pieces[3],
      pieces[4])
  let bpieces: PieceAmount = (pieces[5], pieces[6], pieces[7], pieces[8],
      pieces[9])
  return wpieces in InsufficientMaterial and bpieces in InsufficientMaterial

proc isStalemate*(chess: Chess, color: Color): bool =
  ## Returns true if the `color` player is stalemate in a `chess`.
  return (chess.genLegalMoves(color) == @[] and not chess.isInCheck(color)) or
      chess.board.checkInsufficientMaterial()
