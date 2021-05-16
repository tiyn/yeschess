# ychess

![ychess-logo](./art/ychess.png)

ychess is a chess implementation and engine written in nim.

## Usage and contribution

For the following subsections to work properly you need to have `nim.cfg` files
so you don't need to pass all compiler arguments manually.
To automatically create the config files run `nim c -r createCfg.nim` from the
root directory of the project.

### Todos

[TODO.md](./TODO.md) contains a list of features that are planned.

### Command line

To play chess in the commandline simply download the code (or clone the
repository) and run `nim c -r game.nim`.
You can either play the 1v1 hotseat mode or a single player mode vs the engine.

### Lichess

ychess uses the lichess api to make playing more convenient.
An instance of the engine occasionally plays on
[lichess](https://lichess.org/@/tiyn-ychess).
To get into the whitelist just write a ingame message to the account.

If you want to create an instance on lichess yourself you need to set a api
token.
This is done in `src/engine/secret.nim`.
It should have the following structure:

```nim
let api_token* = "<lichess api token for bot>"
```

Following that you will want to set your username into the whitelist in
`src/engine/lichessBridge.nim`.
After that you can start the lichess bot by running
`nim c -r src/engine/lichessBridge.nim`.

## Project Structure

- `art` - contains pictures and arts not used in the code.
- `bin` - is not pushed to the git repository but contains all binaries and will
be created if you compile a program.
- `htmldocs` - is not pushed to the git repository but contains all
automatically generated documentation.
- `ressources` - is not pushed to the git repository but contains all
the data used in source code but not being source code itself (e.g. databases).
- `src` - is the root folder for all programs except tests.
- `tests` - contains all tests.

### Documentation

Documentation is written into the code via DocGen.
For this reason it is not saved in this repository.
To extract it into html (assuming you want the documentation for `game.nim`)
run `nim doc --project --index:on --outdir:htmldocs game.nim`.

## Additional Documentation

### Moves

Moves are read from the commandline as
[pure coordinate notation](https://www.chessprogramming.org/Algebraic_Chess_Notation#Pure_coordinate_notation).
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

### Code Style Guide

Make sure to take a look at the
[official nim style guide](https://nim-lang.org/docs/nep1.html).
All conventions should be applied to this code.

Additionally there are a bunch of steps to make the code more consistent.

#### Constants

Constants should start with an uppercase letter but shouldn't be written in all
caps (`const FooBar = 2`).

#### Whitespaces

Basic arithmetic operations should be surrounded by spaces for example: `1 + 3`.
This however is not true for negation of a single value (`-1`) or if the
arithmetic operation is done inside array brackets or in iterators (`a+1..3`,
`a[c+3]`).

#### Function calls

Determining the length of a string, array, etc should not be done via a function
(`len(array)`) but by appending it like `array.len`.
In the same style function calls should be done (`chess.convertToFen()` instead
of `convertToFen(chess)`).
This however is not true if the function takes a first argument that is not an
abstract datatype like the joinPath function (all the parameters are strings).

#### booleans and logic

If statements should not contain outer brackets.
In some cases (especially concatenations of `and` and `or`) inner brackets are
useful to increase readability in complexer logic formulas.

When assigning booleans with logical formulas outer brackets are expected
(`var boolVar = (1 == 1)`).
