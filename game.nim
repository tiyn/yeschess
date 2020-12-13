from strutils import parseInt
import rdstdin

import ./chess

proc notation_to_move(notation: string, color: Color): Move =
  ## Convert simplified algebraic chess `notation` to a move object, color of player is `color`.
  try:
    var move: Move
    var start = field_to_ind(notation[0..1])
    var dest = field_to_ind(notation[2..3])
    move = get_move(start, dest, color)
    if (len(notation) > 4):
      var prom_str = $notation[4]
      var prom: int
      case prom_str:
        of "Q":
          prom = QueenID * ord(color)
        of "R":
          prom = RookID * ord(color)
        of "B":
          prom = BishopID * ord(color)
        of "N":
          prom = KnightID * ord(color)
      move = get_move(start, dest, prom, color)
    return move
  except IndexError:
    var move: Move
    return move

proc run_game(): void =
  var game = init_game()
  game.echo_board(game.to_move)
  while not game.is_checkmate(game.to_move):
    echo "Make a move"
    echo game.to_move
    var move = readLine(stdin)
    while not game.checked_move(notation_to_move(move, game.to_move)):
      move = readLine(stdin)
    game.echo_board(game.to_move)
  if game.is_checkmate(game.to_move):
    echo $game.to_move & " was checkmated"
  if game.is_stalemate(game.to_move):
    echo "Stalemate"

run_game()
