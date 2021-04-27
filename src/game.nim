import parseutils

import ./chess.nim
import ./engine.nim

proc runGameHotseat*(): void =
  ## Initializes and runs a game of chess as hotseat.
  var game = initGame()
  var draw: string
  game.echoBoard(game.toMove)
  while not game.isCheckmate(game.toMove) and not game.isStalemate(game.toMove):
    echo "Make a move"
    echo game.toMove
    var move = readLine(stdin)
    while not game.checkedMove(notationToMove(move, game.toMove)):
      move = readLine(stdin)
    game.echoBoard(game.toMove)
    if (game.isDrawClaimable):
      echo "Do you want to claim a draw? (y/N)"
      draw = readLine(stdin)
      if (draw == "y"):
        echo "Draw claimed"
        break
  if game.isCheckmate(game.toMove):
    echo $game.toMove & " was checkmated"
  if game.isStalemate(game.toMove):
    echo "Stalemate"

proc runGameSolo*(color: Color, difficulty: int): void =
  ## Initializes and runs a solo game of chess.
  ## The player plays as `color`.
  var game = initGame()
  var draw: string
  while not game.isCheckmate(game.toMove) and not game.isStalemate(game.toMove):
    if (game.toMove == color):
      game.echoBoard(color)
      echo "Make a move"
      var hMove = readLine(stdin)
      while not game.checkedMove(notationToMove(hMove, game.toMove)):
        hMove = readLine(stdin)
      game.echoBoard(color)
      if (game.isDrawClaimable):
        echo "Do you want to claim a draw? (y/N)"
        draw = readLine(stdin)
        if (draw == "y"):
          echo "Draw claimed"
          break
    else:
      var cMove = bestMove(game, 3)
      game.checkedMove(cMove)
  if game.isCheckmate(game.toMove):
    echo $game.toMove & " was checkmated"
  if game.isStalemate(game.toMove):
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

menu()
