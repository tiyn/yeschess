import parseutils

import ./chess.nim
import ./engine.nim

proc runGameHotseat*(): void =
  ## Initializes and runs a game of chess as hotseat.
  var chess = initChess()
  var draw: string
  chess.echoBoard(chess.toMove)
  while not chess.isCheckmate(chess.toMove) and not chess.isStalemate(chess.toMove):
    echo "Make a move"
    echo chess.toMove
    var move = readLine(stdin)
    while not chess.checkedMove(notationToMove(move, chess.toMove)):
      move = readLine(stdin)
    chess.echoBoard(chess.toMove)
    if (chess.isDrawClaimable()):
      echo "Do you want to claim a draw? (y/N)"
      draw = readLine(stdin)
      if (draw == "y"):
        echo "Draw claimed"
        break
  if chess.isCheckmate(chess.toMove):
    echo $chess.toMove & " was checkmated"
  if chess.isStalemate(chess.toMove):
    echo "Stalemate"

proc runGameSolo*(color: Color, difficulty: int): void =
  ## Initializes and runs a solo game of chess.
  ## The player plays as `color`.
  echo("run game")
  var chess = initChess()
  var draw: string
  while not chess.isCheckmate(chess.toMove) and not chess.isStalemate(chess.toMove):
    if (chess.toMove == color):
      chess.echoBoard(color)
      echo "Make a move"
      var hMove = readLine(stdin)
      while not chess.checkedMove(notationToMove(hMove, chess.toMove)):
        hMove = readLine(stdin)
      chess.echoBoard(color)
      if (chess.isDrawClaimable):
        echo "Do you want to claim a draw? (y/N)"
        draw = readLine(stdin)
        if (draw == "y"):
          echo "Draw claimed"
          break
    else:
      var cMove = bestMove(chess, difficulty)
      chess.checkedMove(cMove)
  if chess.isCheckmate(chess.toMove):
    echo $chess.toMove & " was checkmated"
  if chess.isStalemate(chess.toMove):
    echo "Stalemate"

proc menu(): void =
  ## Presents choices on what to play.
  echo("\nWelcome to YchESs!\n\n\n")
  var input: string
  var playerCount: int
  while true:
    echo("How many players? (1/2)")
    input = readLine(stdin)
    discard parseInt(input, playerCount, 0)
    if (playerCount == 1 or playerCount == 2):
      break
  if playerCount == 1:
    var color: string
    var difficulty: int
    while true:
      echo("Choose the difficulty for the engine (1-10)")
      input = readLine(stdin)
      discard parseInt(input, difficulty, 0)
      if (difficulty >= 1 and difficulty <= 10):
        break
    while true:
      echo("Do you want to play Black or White? (B/W)")
      color = readLine(stdin)
      if (color == "B"):
        echo("\n\n\n")
        runGameSolo(Color.Black, difficulty)
        break
      elif (color == "W"):
        echo("\n\n\n")
        runGameSolo(Color.White, difficulty)
        break
  else:
    echo("\n\n\n")
    runGameHotseat()

when isMainModule:
  menu()
