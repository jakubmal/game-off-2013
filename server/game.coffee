_ = require 'underscore'
Board = require './board'
Player = require './player'

boards = []

exports.show = (req, res) ->
  res.render 'show', key: req.query.key

exports.index = (req, res) ->
  res.render 'boards', {boards, limit: Board.PLAYERS_LIMIT}

exports.playerSocketHandler = (socket) ->
  socket.emit 'welcome'
  socket.on 'join', ({key}) ->
    board = _.findWhere boards, {key}
    unless board?
      board = new Board key
      board.onDead = () -> boards = _.without boards, board
      boards.push board

    player = new Player socket
    board.addPlayer player
    board.startIfFull()
