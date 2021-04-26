# ychess

Attention: **The Chess engine is not finished yet.**

![ychess-logo](ychess.png)

ychess is a chess implementation and engine written in nim.

## Usage

Simply download the code and run `nim c -r game.nim`.
You can now play a 1v1 hotseat game of chess in the commandline.

## Testing

Testing is done by `einheit` by [jyapayne](https://github.com/jyapayne/einheit).
All legal chess moves are implemented in `chess.nim` and tested by the TestSuite
in `test.nim`.
You can simply run the tests with `nim c -r test.nim`.

## Documentation

Documentation is written into the code via DocGen.
For this reason it is not saved in this repository.
To extract it into html run `nim doc --project --index:on --outdir:htmldocs game.nim`

### Board Representation

Due to easier off the board checking a
[10x12](https://www.chessprogramming.org/10x12_Board) board is used.

### Engine

The engine uses a simple implementation of the
[Minimax](https://www.chessprogramming.org/Minimax)-algorithm.
