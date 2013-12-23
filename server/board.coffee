_ = require 'underscore'
Map = require './map'
Player = require './player'

PLAYERS_LIMIT = 2

class Board
  @PLAYERS_LIMIT: PLAYERS_LIMIT
  constructor: (@key) ->
    @players = []
    @colors = ['red', 'green', 'blue', 'purple']
    @map = new Map

    # who can currently make move
    @currentPlayer = null

    @onDead = (->)

  genPlayer: (socket) ->
    if @players.length >= PLAYERS_LIMIT
      return

    player = new Player socket, @colors.shift()

    @players.push player
    player.mapChange @map.fields
    player.onDisconnect = () => @removePlayer(player)
    player.onMakeMove = (data) => @playerMakeMove(player, data)
    player.onEndTurn = () => @endTurn(player)

  removePlayer: (player) ->
    @players = _.without @players, player
    player.lost()

    @die() if @players.length == 0

  startIfFull: () ->
    @start() if PLAYERS_LIMIT == @players.length

  start: () ->
    @playersCount = @players.length
    @turnCount = 0

    @map.initCapitals @players
    player.gameStarted(@map.fields) for player in @players
    @startTurn()


  startTurn: () ->
    @turnCount = 0
    @map.genArmies()
    @mapChange()
    @setCurrentPlayer(@players[0])
    

  setCurrentPlayer: (player) ->
    @currentPlayer.unsetCurrent() if @currentPlayer?
    @currentPlayer = player
    @currentPlayer.setCurrent()

  goToNextPlayer: () ->
    @players.push(@players.shift())
    @setCurrentPlayer(@players[0])
    @turnCount++
    @startTurn() if @turnCount == @playersCount

  playerMakeMove: (player, {source, dest}) ->
    @map.makeMove source, dest
    @mapChange()

  endTurn: (player) ->
    # return unless @currentPlayer == player
    @goToNextPlayer()

  lookForWinner: () ->
    if players.length == 1
      players[0].won()
  mapChange: () ->
    player.mapChange(@map.fields) for player in @players

  die: ->
    player.reject() for player in @players

    @onDead()

module.exports = Board
