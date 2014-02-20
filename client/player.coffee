MOVES_PER_TURN = 5
TIME_PER_TURN_S = 15
TIME_PER_TURN_MS = 1000 * TIME_PER_TURN_S


class Player
  constructor: (@socket, key) ->
    _this = this
    @movesThisTurn = 1
    @clockTicking = 0
    @isCurrent = false
    @onMapChange = ->
    @socket.on 'color', ({@color}) => console.log @color
    @socket.on 'mapChange', ({fields}) => @onMapChange fields
    @socket.on 'movesCount', ({movesCount}) => @movesThisTurn = movesCount

    @socket.emit 'join', {key}

    @socket.on 'rejected', () -> window.location = '/games'

    @socket.on 'gameStarted', ({fields}) =>
      @onMapChange fields

    @socket.on 'setCurrent', () =>
      @isCurrent = true
      @startClock()
      alertify.success 'Your move'
      console.log 'current'

    @socket.on 'unsetCurrent', () =>
      @isCurrent = false
      console.log 'not current'

    @socket.on 'lost', () ->
      alertify.set({labels:{
        ok: 'Back to game list',
        cancel: 'Stay and watch game'
      }})
      confirmed = alertify.confirm 'You lost'
      console.log confirmed
      # if confirmed 
      #   console.log 'confirmed'
      #   window.location.href = '/games'

    @socket.on 'won', ()->
      alertify.alert 'Congratulations - You won!'
      #window.location.href = '/games'

  makeMove: (data) =>
    if @isCurrent == true
      @socket.emit 'makeMove', data 
      @movesThisTurn--
    else
      alertify.error 'Wait for your turn'
      console.log 'not Your Turn'
    @endTurn() if @movesThisTurn == 0
    
  evaluateMovesThisTurn: () ->
    @socket.emit 'findArmies'  
 
  endTurn: ()->
    return unless @isCurrent
    alertify.log 'Turn has ended'
    @clearClock()
    @evaluateMovesThisTurn()
    @socket.emit 'endTurn'

  giveSpeach: () ->
    @socket.emit 'giveSpeach'

  surrender: () ->
    @socket.emit 'surrender'

  startClock: () ->
    self = this
    startTime = new Date().getTime()
    timer = $('.timer')

    changeClock = () ->
      timer.addClass 'red'
      now = new Date().getTime();
      timeLeft = Math.round((TIME_PER_TURN_MS - (now - startTime))/1000)
      clockTime = '00:' + timeLeft if timeLeft >= 10
      clockTime = '00:0' + timeLeft if timeLeft < 10
      timer.html clockTime

      if timeLeft <= 0  
        self.endTurn()

    @clockTicking = setInterval changeClock, 1000 
  clearClock: () ->
    timer = $('.timer')
    clearInterval @clockTicking if @clockTicking != 0
    @clockTicking = 0
    timer.removeClass 'red'
    timer.html "00:15"

@Player = Player
