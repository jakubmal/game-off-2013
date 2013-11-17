idCounter = 0
sockets = []

class Player
  constructor: (socket, @color) ->
    @id = idCounter++
    sockets[@id] = socket

    @onMakeMove = (->)

    sockets[@id].emit 'color', {@color}

  gameStarted: (fields) ->
    sockets[@id].emit 'gameStarted', {fields}
    sockets[@id].on 'makeMove', (data) => console.log(data); @onMakeMove(data)
    sockets[@id].on 'endTurn', () => @onEndTurn()
    sockets[@id].on 'disconnect', () => @onDisconnect()

  setCurrent: () ->
    sockets[@id].emit 'setCurrent'

  unsetCurrent: () ->
    sockets[@id].emit 'unsetCurrent'

  mapChange: (fields) ->
    sockets[@id].emit 'mapChange', {fields}

  reject: () ->
    sockets[@id].emit 'rejected'

  lost: () ->
    sockets[@id].emit 'lost'

  won: () ->
    sockets[@id].emit 'won'

  serialize: () ->
    _.omit @, 'socket'

module.exports = Player
