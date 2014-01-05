MOVES_PER_TURN = 5

class Player
  constructor: (@socket, key) ->
    _this = this 
    @movesThisTurn = 1
    @isCurrent = false
    @onMapChange = ->
    @socket.on 'color', ({@color}) => console.log @color
    @socket.on 'mapChange', ({fields}) => @onMapChange fields
    @socket.on 'movesCount', ({movesCount}) => @movesThisTurn = movesCount

    @socket.emit 'join', {key}

    @socket.on 'rejected', () -> window.location = '/games'

    @socket.on 'gameStarted', ({fields}) =>
      @onMapChange fields

    @socket.on 'setCurrent', () ->
      _this.isCurrent = true
      alertify.success 'Your move'
      console.log 'current'

    @socket.on 'unsetCurrent', () ->
      _this.isCurrent = false
      console.log 'not current'

    @socket.on 'lost', () ->
      alertify.set({labels:{
        ok: 'Back to game list',
        cancel: 'Stay and watch game'
      }})
      confirmed = alertify.confirm 'You lost'
      console.log confirmed
      #if confirmed then window.location.href = '/games'

    @socket.on 'won', ()->
      alertify.alert 'Congratulations - You won!'
      #window.location.href = '/games'

  makeMove: (data) ->
    if @isCurrent == true
      @socket.emit 'makeMove', data 
      @movesThisTurn--
    else
      alertify.error 'Wait for your turn'
      console.log 'not Your Turn'
    @endTurn() if @movesThisTurn == 0
    
  evaluateMovesThisTurn: () ->
    # armiesFound = window.map.findArmies(@color)
    # console.log armiesFound
    # if armiesFound > MOVES_PER_TURN then @movesThisTurn =  MOVES_PER_TURN else @movesThisTurn = armiesFound
    @socket.emit 'findArmies'
  endTurn: ->
    alertify.log('Turn has ended')
    @evaluateMovesThisTurn()
    @socket.emit 'endTurn'

  giveSpeach: ->
    @socket.emit 'giveSpeach'
  surrender: ->
    @socket.emit 'surrender'

@Player = Player
