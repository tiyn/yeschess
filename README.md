# ychess

Attention: **The Chess engine is not finished yet.**

![ychess-logo](ychess.png)

ychess is a chess implementation and engine written in nim.

## Usage

To play chess in the commandline simply download the code and run `nim c -r game.nim`.
You can either play the 1v1 hotseat mode or a single player mode vs the engine.

### Lichess

ychess uses the lichess api with the python plugin [berserk](https://github.com/rhgrant10/berserk).
An instance of the engine occasionally plays on [lichess](https://lichess.org/@/tiyn-ychess).
To get into the whitelist just write a ingame message to the account.

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
