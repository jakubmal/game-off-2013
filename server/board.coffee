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
    player.onGiveSpeach = () => @map.giveSpeach(player)
    player.onCountArmies = () => @countArmies(player)

  removePlayer: (player) ->
    @players = _.without @players, player
    @players[0].won() if @players.length == 1
    @die() if @players.length == 0
    @map.removeArmies(player)

  startIfFull: () ->
    @start() if PLAYERS_LIMIT == @players.length

  start: () ->
    @playersCount = @players.length
    @turnCount = 0

    @map.initCapitals @players
    player.gameStarted(@map.fields) for player in @players
    @setCurrentPlayer(@players[0])
    @startTurn()

  startTurn: () ->
    @turnCount = 0
    @map.genArmies()
    @mapChange()
    
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

  endTurn: () ->
    @goToNextPlayer()

  mapChange: () ->
    player.mapChange(@map.fields) for player in @players

  die: ->
    player.reject() for player in @players
    @onDead()

  countArmies: (player)->
    player.sendArmiesCount(@map.countArmies(player))

module.exports = Board
