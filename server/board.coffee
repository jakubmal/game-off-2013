_ = require 'underscore'
Map = require './map'

PLAYERS_LIMIT = 2

class Board
  @PLAYERS_LIMIT: PLAYERS_LIMIT
  constructor: (@key) ->
    @players = []
    @map = new Map

    # who can currently make move
    @currentPlayer = null

    @onDead = (->)

  addPlayer: (player) ->
    if @players.length >= PLAYERS_LIMIT
      player.reject()
      return

    @players.push player
    player.onDisconnect = () => @removePlayer(player)
    player.onEndTurn = () => @endTurn(player)

  removePlayer: (player) ->
    console.log 'removePlayer'

    @players = _.without @players, player
    @playerLost player

    console.log "players length: #{@players.length}"
    @die() if @players.length == 0

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
      @die()

  die: ->
    player.reject() for player in @players

    console.log 'ondead'
    @onDead()

module.exports = Board
