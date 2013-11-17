class Player
  constructor: (@socket, key) ->
    @socket.emit 'join', {key}
    @socket.on 'rejected', () -> window.location = '/games'
    @socket.on 'gameStarted', () ->
      console.log 'gameStarted'
    @socket.on 'setCurrent', () ->
      console.log 'setCurrent'
    @socket.on 'unsetCurrent', () ->
      console.log 'unsetCurrent'

  endTurn: ->
    @socket.emit 'endTurn'

@Player = Player
