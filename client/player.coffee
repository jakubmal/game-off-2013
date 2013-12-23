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
      console.log 'not current'
    @socket.on 'lost', () ->
      alertify.set({labels:{
        ok: 'Back to game list',
        cancel: 'Stay and watch game'
      }})
      alertify.confirm('Your lost')
    @socket.on 'won', ()->
      alertify.alert('Congratulations - You won!')

  makeMove: (data) ->
    if @isCurrent == true
      @socket.emit 'makeMove', data 
      @movesThisTurn--
    else
      alertify.error('Wait for your turn')
      console.log 'not Your Turn'
      @socket.emit 'notYourTurn'
    @endTurn() if @movesThisTurn == 0
    
  evaluateMovesThisTurn: () ->
    armiesCount = window.map.findArmies(@color)
    if armiesCount > MOVES_PER_TURN then return MOVES_PER_TURN else return armiesCount

  endTurn: ->
    alertify.log('Turn has ended')
    @movesThisTurn = @evaluateMovesThisTurn()+1 # don't know why +1 , but otherwise it doesn't work :(
    @socket.emit 'endTurn'

  giveSpeach: ->

    @socket.emit 'speach'

@Player = Player
