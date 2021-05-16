import db_sqlite
import sequtils
import strutils
import sugar
import tables
import os

include chess

import secret
import project

type
  BookMove* = object
    ## `PossibleMove` capsulates a possible moves in a position with additional
    ## statistics.
    fen*: string # `fen` is the fen string of a position.
    move*: string # `move` describes a move in pure coordinate notation.
    white*: int # `white` is the number of game white won from this position.
    black*: int # `black` is the number of game black won from this position.
    draw*: int # `draw` is the number of game drawn from this position.
    rating*: int # `rating` is the average rating of the player to move.


let dbConn = joinPath(getProjRootDir(), "ressources/openings.db")
let dbUser = ""
let dbPasswd = ""
let dbName = ""

let tableName = "posmoves"

proc initDB(): void =
  ## Initialize the database with a table if it doesnt currently exist.
  let db = open(dbConn, dbUser, dbPasswd, dbName)
  db.exec(sql"""CREATE TABLE IF NOT EXISTS ? (
                   fen    VARCHAR(100) NOT NULL,
                   move   VARCHAR(6) NOT NULL,
                   white  INTEGER NOT NULL,
                   black  INTEGER NOT NULL,
                   draw   INTEGER NOT NULL,
                   rating INTEGER NOT NULL,
                   PRIMARY KEY (fen, move)
                )""", tableName)
  db.close()
  echo("Database initialization done.")

proc storeMove(fen: string, move: string, white: bool, black: bool, draw: bool,
    rating: int): void =
  ## Store a possible `move` done by a player with `rating` (0 for unknown)
  ## in a position described by `fen`.
  ## The result of the game is described by `white`, `black` and `draw`.
  let db = open(dbConn, dbUser, dbPasswd, dbName)
  var query = """
    INSERT INTO ? (fen, move, white, black, draw, rating)
    VALUES (?, ?, ?, ?, ?, ?)
    ON CONFLICT(fen, move) DO UPDATE SET
  """
  if not rating == 0:
    query &= "rating = ((rating * (black + white + draw)) + ?) / (black + white + draw + 1),"
  if white:
    query &= "white = white + 1"
  elif black:
    query &= "black = black + 1"
  else:
    query &= "draw = draw + 1"
  db.exec(sql(query), tableName, fen, move, int(white), int(black), int(draw),
      rating, rating)
  db.close()
  echo("inserted (", join([fen, move, $white, $black, $draw, $rating], ", "),
      ") into ", tableName)

proc loadMove*(fen: string): seq[BookMove] =
  ## Load all possible moves possible in a given position described by `fen`
  ## from the database. Format moves as a BookMove object.
  let db = open(dbConn, dbUser, dbPasswd, dbName)
  let res = db.getAllRows(sql """SELECT move, white, black, draw, rating
                            FROM ?
                            WHERE fen == ?
                            ORDER BY rating DESC
                            """, tableName, fen)
  db.close()
  var fRes: seq[BookMove]
  for entry in res:
    var bookMv: BookMove
    bookMv.fen = fen
    bookMv.move = entry[0]
    bookMv.white = parseInt(entry[1])
    bookMv.black = parseInt(entry[2])
    bookMv.draw = parseInt(entry[3])
    bookMv.rating = parseInt(entry[4])
    fRes.add(bookMv)
  return fRes

proc sanToPcn(sanMoves: string): string =
  ## Convert a list of `sanMoves` to pure coordinate notation (assuming the game
  ## starts in the standard initial position)
  var sanMoveArr = sanMoves.replace("+").replace("x").replace("#").replace(
      "!").replace("?").split(" ")
  sanMoveArr.del(sanMoveArr.high)
  var fSanMoves: string
  var inComment: bool
  for word in sanMoveArr:
    if inComment:
      if word.endsWith("}"):
        inComment = false
    else:
      if word.startsWith("{"):
        inComment = true
        continue
      if not word.endsWith("."):
        fSanMoves &= word & " "
  var revPieceChar = toSeq(PieceChar.pairs).map(y => (y[1], y[0])).toTable
  var chess = initChess()
  var lastChess = chess
  let sanArr = fsanMoves.split(" ")
  var pcnMoves: string
  for sanMove in sanArr:
    var start: string
    var dest: string
    if sanMove.isEmptyOrWhitespace:
      continue
    dest = sanMove[sanMove.high-1..sanMove.high]
    if sanMove.contains("="):
      let promotion = sanMove[sanMove.high]
      if sanMove.len == 5:
        let file = sanMove[0]
        dest = sanMove[1..2] & promotion
        if chess.toMove == Color.White:
          start = file & "7"
        else:
          start = file & "2"
      elif sanMove.len == 4:
        dest = sanMove[0..1] & promotion
        start = indToField(fieldToInd(dest) + ord(chess.toMove) * S)
      chess.checkedMove(notationToMove(start & dest, chess.toMove))
    elif "abcdefgh".contains(sanMove[0]):
      let file = sanMove[0]
      for rank in 1..8:
        start = file & $rank
        if fieldToInd(dest) in chess.genPawnDests(fieldToInd(start), chess.toMove):
          if chess.checkedMove(notationToMove(start & dest, chess.toMove)):
            break
    elif sanMove.startsWith("O-O"):
      if chess.toMove == Color.White:
        start = "e1"
        if sanMove.len == 3:
          dest = "g1"
        else:
          dest = "c1"
      else:
        start = "e8"
        if sanMove.len == 3:
          dest = "g8"
        else:
          dest = "c8"
      chess.checkedMove(notationToMove(start & dest, chess.toMove))
    else:
      var piece = revPieceChar[$sanMove[0]] * ord(chess.toMove)
      if sanMove.len == 3:
        var possibleStarts: seq[string]
        for i, field in chess.board:
          if field == piece:
            possibleStarts.add(indToField(i))
        for possibleStart in possibleStarts:
          if chess.checkedMove(notationToMove(possibleStart & dest,
              chess.toMove)):
            start = possibleStart
            break
      elif sanMove.len == 4:
        if sanMove[1].isDigit():
          let rank = $sanMove[1]
          for file in "abcdefg":
            if chess.board[fieldToInd($file & rank)] == piece:
              start = $file & rank
              chess.checkedMove(notationToMove(start & dest, chess.toMove))
              break
          continue
        else:
          let file = sanMove[1]
          for rank in 1..8:
            if chess.board[fieldToInd(file & $rank)] == piece:
              start = file & $rank
              chess.checkedMove(notationToMove(start & dest, chess.toMove))
              break
      elif sanMove.len == 5:
        start = sanMove[1..2]
        dest = sanMove[3..4]
        chess.checkedMove(notationToMove(start & dest, chess.toMove))
    if lastChess == chess:
      chess.echoBoard(Color.White)
      echo("ERROR OCCURED")
      return ""
    pcnMoves.add(start & dest & " ")
    lastChess = chess
  return pcnMoves

proc iterMultiPGN(fileP: string): void =
  ## Iterate through a (multi) PGN file at `fileP` and store the games in the
  ## opening database. This function is designed to work with multi PGN files
  ## from lichess, but should also work for other formats (elo may be not working)
  var sanMoves: string
  var secondSpace: bool
  var white: bool
  var black: bool
  var wElo: int
  var bElo: int
  var i: int
  var chess: Chess
  for line in lines(fileP):
    if line.isEmptyOrWhitespace:
      if not secondSpace:
        secondSpace = true
      else:
        secondSpace = false
        chess = initChess()
        for move in sanToPcn(sanMoves).split(" "):
          var rating = 0
          if chess.toMove == Color.White:
            rating = wElo
          else:
            rating = bElo
          storeMove(chess.convertToFen(), move, white, black, not white and
              not black, rating)
          chess.checkedMove(notationToMove(move, chess.toMove))
        i += 1
        sanMoves = ""
        white = false
        black = false
        wElo = 0
        bElo = 0
        if i == 1000:
          return
    if line.startsWith("["):
      if line.contains("Result "):
        if line.contains("1-0"):
          white = true
        elif line.contains("0-1"):
          black = true
      elif line.contains("WhiteElo"):
        var eloStr = line.replace("[WhiteElo \"").replace("\"]")
        if eloStr != "?":
          wElo = parseInt(eloStr)
        else:
          wElo = 0
      elif line.contains("BlackElo"):
        var eloStr = line.replace("[BlackElo \"").replace("\"]")
        if eloStr != "?":
          bElo = parseInt(eloStr)
        else:
          bElo = 0
    else:
      sanMoves &= line

when isMainModule:
  initDB()
  #iterMultiPGN("file.pgn")
