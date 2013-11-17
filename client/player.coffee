class Player
  constructor: (@socket, key) ->
    @onMapChange = ->
    @socket.on 'color', ({@color}) => console.log @color
    @socket.on 'mapChange', ({fields}) => @onMapChange fields

    @socket.emit 'join', {key}

    @socket.on 'rejected', () -> window.location = '/games'

    @socket.on 'gameStarted', ({fields}) =>
      @onMapChange fields

    @socket.on 'setCurrent', () ->
      console.log 'setCurrent'
    @socket.on 'unsetCurrent', () ->
      console.log 'unsetCurrent'

  makeMove: (data) ->
    console.log data
    @socket.emit 'makeMove', data

  endTurn: ->
    @socket.emit 'endTurn'

@Player = Player
