_ = require 'underscore'

class Board
  constructor: () ->
    @players = []

    # who can currently make move
    @currentPlayer = null

  addPlayer: (player) ->
    @players.push player
    player.onDisconnect = () => @removePlayer(player)
    player.onEndTurn = () => @endTurn(player)

  removePlayer: (player) ->
    @players = _.without @players, player

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

module.exports = Board
