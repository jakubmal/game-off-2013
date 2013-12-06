MOVES_PER_TURN = 5

class Player
  constructor: (@socket, key) ->
    _this = this 
    @movesThisTurn = MOVES_PER_TURN
    @isCurrent = false
    @onMapChange = ->
    @socket.on 'color', ({@color}) => console.log @color
    @socket.on 'mapChange', ({fields}) => @onMapChange fields

    @socket.emit 'join', {key}

    @socket.on 'rejected', () -> window.location = '/games'

    @socket.on 'gameStarted', ({fields}) =>
      @onMapChange fields

    @socket.on 'setCurrent', () ->
      window.player.isCurrent = true
      console.log 'current'
    @socket.on 'unsetCurrent', () ->
      window.player.isCurrent = false
      console.log 'unCurrent'

  makeMove: (data) ->
    if @isCurrent == true
      @socket.emit 'makeMove', data 
      @movesThisTurn--
    else
      console.log 'not Your Turn'
      @socket.emit 'notYourTurn'
    @endTurn() if @movesThisTurn == 0
    
  endTurn: ->
    @socket.emit 'endTurn'

@Player = Player
