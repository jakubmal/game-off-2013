class Player
  constructor: (@socket) ->
    @onMakeMove = (->)
    @onEndTurn = (->)

  gameStarted: () ->
    @socket.emit 'gameStarted'
    @socket.on 'makeMove', ({source, dest}) => @onMakeMove(source, dest)
    @socket.on 'endTurn', () => @onEndTurn()
    @socket.on 'disconnect', () => @onDisconnect()

  setCurrent: () ->
    @socket.emit 'setCurrent'

module.exports = Player
