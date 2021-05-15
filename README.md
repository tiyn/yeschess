# ychess

![ychess-logo](./art/ychess.png)

ychess is a chess implementation and engine written in nim.

## Quick Setup

To play chess in the commandline simply download the code (or clone the
repository) and run `nim c -r game.nim`.
You can either play the 1v1 hotseat mode or a single player mode vs the engine.

Additionally ychess uses the lichess api to make playing more convenient.
An instance of the engine occasionally plays on
[lichess](https://lichess.org/@/tiyn-ychess).
To get into the whitelist just write a ingame message to the account.

## Project Structure

- `art` - contains pictures and arts not used in the code.
- `bin` - is not pushed to the git repository but contains all binaries and will
be created if you compile a program.
- `htmldocs` - is not pushed to the git repository but contains all
automatically generated documentation.
- `src` - is the root folder for all programs except tests.
- `tests` - contains all tests.

### Documentation

Documentation is written into the code via DocGen.
For this reason it is not saved in this repository.
To extract it into html (assuming you want the documentation for `game.nim`)
run `nim doc --project --index:on --outdir:htmldocs game.nim`.

## General Design Choices

### Moves

Moves are read from the commandline as [pure coordinate notation](https://www.chessprogramming.org/Algebraic_Chess_Notation#Pure_coordinate_notation).
The inner program will convert this notation to a move-tuple.

### Board Representation

Due to easier off the board checking a
[10x12](https://www.chessprogramming.org/10x12_Board) board is used.

### Engine

The engine uses a simple implementation of the
[NegaMax](https://www.chessprogramming.org/NegaMax)-algorithm with
[Alpha-Beta-Pruning](https://www.chessprogramming.org/Alpha-Beta#Negamax_Framework).
For the evaluation function each piece has a corresponding value.
Additionally [piece-square tables](https://www.chessprogramming.org/Piece-Square_Tables)
are used.
