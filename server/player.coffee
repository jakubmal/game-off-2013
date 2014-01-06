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
    sockets[@id].on 'makeMove', (data) => @onMakeMove(data)
    sockets[@id].on 'endTurn', () => @onEndTurn()
    sockets[@id].on 'disconnect', () => @onDisconnect()
    sockets[@id].on 'findArmies', () => @onCountArmies()
    sockets[@id].on 'surrender', () => @onDisconnect()
    sockets[@id].on 'giveSpeach', () => @onGiveSpeach()

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
    @onDisconnect()

  won: () ->
    sockets[@id].emit 'won'
    @onDisconnect()

  serialize: () ->
    _.omit @, 'socket'

  sendArmiesCount: (movesCount) ->
    sockets[@id].emit 'movesCount', {movesCount}

module.exports = Player
