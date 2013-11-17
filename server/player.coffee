class Player
  constructor: (@socket) ->
    @onMakeMove = (->)
    @onEndTurn = (->)

  gameStarted: (fields) ->
    @socket.emit 'gameStarted', {fields}
    @socket.on 'makeMove', ({source, dest}) => @onMakeMove(source, dest)
    @socket.on 'endTurn', () => @onEndTurn()
    @socket.on 'disconnect', () => @onDisconnect()

  setCurrent: () ->
    @socket.emit 'setCurrent'

  unsetCurrent: () ->
    @socket.emit 'unsetCurrent'

  mapChange: (fields) ->
    @socket.emi 'mapChange', {fields}

  reject: () ->
    @socket.emit 'rejected'

  lost: () ->
    @socket.emit 'lost'

  won: () ->
    @socket.emit 'won'

module.exports = Player
