class Player
  constructor: (@socket, key) ->
    @socket.emit 'join', {key}
    @socket.on 'gameStarted', () ->
      console.log 'gameStarted'
    @socket.on 'setCurrent', () ->
      console.log 'setCurrent'

  endTurn: ->
    @socket.emit 'endTurn'

@Player = Player
