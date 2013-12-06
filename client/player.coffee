MOVES_PER_TURN = 5

class Player
  constructor: (@socket, key) ->
    _this = this 
    @movesThisTurn = 1
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
      console.log @movesThisTurn
      @socket.emit 'makeMove', data 
      @movesThisTurn--

    else
      console.log 'not Your Turn'
      @socket.emit 'notYourTurn'
    @endTurn() if @movesThisTurn == 0
    
  evaluateMovesThisTurn: () ->
    armies = window.map.findArmies(@color)
    if armies > MOVES_PER_TURN then return MOVES_PER_TURN else return armies
  endTurn: ->
    @movesThisTurn = @evaluateMovesThisTurn()+1 # don't know why +1 , but otherwise it doesn't work :(
    console.log @movesThisTurn
    @socket.emit 'endTurn'

@Player = Player
