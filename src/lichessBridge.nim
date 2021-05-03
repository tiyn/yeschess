import nimpy
import asyncnet, asyncdispatch

import ./secret.nim
import ./chess.nim
import ./engine.nim

let berserk = pyImport("berserk")

var session = berserk.TokenSession(secret.api_token)
var client = berserk.Client(session = session)

let engineID = "tiyn-ychess"
let engineDifficulty = 3
let toAccept = ["tiynger"]


proc playLichessGame(id: string) {.async.} =
  ## Plays a lichess game with `id` asynchronously.
  var color: Color
  var chess = initChess()
  for event in client.bots.stream_game_state(id):
    echo(event)
    if $event["type"] in ["gameState", "gameFull"]:
      var movesString: PyObject
      if $event["type"] == "gameFull":
        echo("gameFull received")
        movesString = event["state"]["moves"]
        if $event["white"]["id"] == engineID:
          color = Color.White
        if $event["black"]["id"] == engineID:
          color = Color.Black
      else:
        echo("gameState received")
        movesString = event["moves"]
      if $movesString != "":
        var moves = movesString.split(" ")
        chess.checkedMove(notationToMove($moves[-1], chess.toMove))
        chess.echoBoard(chess.toMove)
      if chess.toMove == color:
        echo("engine has to make a move")
        var bestMove = moveToNotation(chess.bestMove(engineDifficulty), chess.board)
        echo(bestMove)
        discard client.bots.make_move(id, bestMove)

proc acceptChallenge(whiteList: openArray[string]): void =
  ## Accepts a challenge of users in a `whiteList` and starts the
  ## game process for each.
  var events = client.bots.stream_incoming_events()
  for event in events:
    echo(event)
    if $event["type"] == "challenge":
      var challenger = $event["challenge"]["challenger"]["id"]
      var id = $event["challenge"]["id"]
      var speed = $event["challenge"]["speed"]
      if challenger in whiteList and speed == "correspondence":
        echo("challenge of ", challenger, " whiteList: ", id)
        discard client.bots.accept_challenge(id)
        discard playLichessGame($event["challenge"]["id"])
      else:
        discard client.bots.decline_challenge(id)
        echo("challenge of ", challenger, " whiteList: ", id)


when isMainModule:
  acceptChallenge(toAccept)
