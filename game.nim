import ./chess

# Testing

var game = chess.init_game()
game.checked_move(field_to_ind("e2"),field_to_ind("e4"),Color.White)
game.checked_move(field_to_ind("e7"),field_to_ind("e6"),Color.Black)
game.checked_move(field_to_ind("g2"),field_to_ind("g4"),Color.White)
game.checked_move(field_to_ind("d8"),field_to_ind("h4"),Color.Black)
game.echo_board(Color.White)
echo game.is_checkmate(Color.White)
echo game.is_stalemate(Color.White)
