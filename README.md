# ychess

![ychess-logo](ychess.png)

ychess is a chess implementation written in nim.
A chess engine is planned.

## Todo

- draw by
  - 50-move rule

## Usage

Simply download the code and run `nim c -r game.nim`.
You can now play a 1v1 hotseat game of chess in the commandline.

## Testing

Testing is done by `einheit` by [jyapayne](https://github.com/jyapayne/einheit).
All legal chess moves are implemented in `chess.nim` and tested by the TestSuite
in `test.nim`.
You can simply run the tests with `nim c -r test.nim`.
