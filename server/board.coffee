_ = require 'underscore'

PLAYERS_LIMIT = 2

class Board
  @PLAYERS_LIMIT: PLAYERS_LIMIT
  constructor: (@key) ->
    @players = []

    # who can currently make move
    @currentPlayer = null

  addPlayer: (player) ->
    if @players.length >= PLAYERS_LIMIT
      player.reject()
      return

    @players.push player
    player.onDisconnect = () => @removePlayer(player)
    player.onEndTurn = () => @endTurn(player)

  removePlayer: (player) ->
    @players = _.without @players, player
    @playerLost player

    @reset() if @players.length == 0

  startIfFull: () ->
    console.log @players.length
    @start() if 2 == @players.length

  start: () ->
    player.gameStarted() for player in @players
    @setCurrentPlayer(@players[0])

  setCurrentPlayer: (player) ->
    @currentPlayer.unsetCurrent() if @currentPlayer?
    @currentPlayer = player
    @currentPlayer.setCurrent()

  goToNextPlayer: () ->
    @players.push(@players.shift())
    @setCurrentPlayer(@players[0])

  playerMakeMove: (player) ->
    return unless @currentPlayer == player

  endTurn: (player) ->
    return unless @currentPlayer == player
    @goToNextPlayer()

  playerLost: (player) ->
    player.lost()
    otherPlayers = _.without @players, player
    if otherPlayers.length == 1
      otherPlayers[0].won()

    @reset()

  reset: ->

module.exports = Board
