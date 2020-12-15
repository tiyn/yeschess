from strutils import parseInt
import rdstdin

import ./chess

proc runGame(): void =
  var game = initGame()
  game.echoBoard(game.toMove)
  while not game.isCheckmate(game.toMove) and not game.isStalemate(game.toMove):
    echo "Make a move"
    echo game.toMove
    var move = readLine(stdin)
    while not game.checkedMove(notationToMove(move, game.toMove)):
      move = readLine(stdin)
    game.echoBoard(game.toMove)
  if game.isCheckmate(game.toMove):
    echo $game.toMove & " was checkmated"
  if game.isStalemate(game.toMove):
    echo "Stalemate"

runGame()
