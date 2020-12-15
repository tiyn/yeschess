from strutils import parseInt
import rdstdin

import ./chess

proc runGame(): void =
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

runGame()
