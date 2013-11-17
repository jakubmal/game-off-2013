class Player
  constructor: (@socket) ->
    @onMakeMove = (->)
    @onEndTurn = (->)

  gameStarted: () ->
    @socket.emit 'gameStarted'
    @socket.on 'makeMove', ({source, dest}) => @onMakeMove(source, dest)
    @socket.on 'endTurn', () => @onEndTurn()
    @socket.on 'disconnect', () => console.log('KUUUUURWA'); @onDisconnect()

  setCurrent: () ->
    @socket.emit 'setCurrent'

  unsetCurrent: () ->
    @socket.emit 'unsetCurrent'

  reject: () ->
    @socket.emit 'rejected'

  lost: () ->
    @socket.emit 'lost'

  won: () ->
    @socket.emit 'won'

module.exports = Player
