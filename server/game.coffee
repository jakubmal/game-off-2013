Board = require './board'
Player = require './player'

exports.show = (req, res) ->
  res.render 'show', key: req.query.key

exports.index = (req, res) ->
  boards = [
    { key: 'chuj', players: [1,2] }
    { key: 'chuj2', players: [1,2] }
    { key: 'chuj5', players: [1] }
    { key: 'chuj6', players: [1] }
    { key: 'chuj7', players: [1,2] }
  ]
  res.render 'boards', {boards, limit: Board.PLAYERS_LIMIT}

boards = {}
exports.playerSocketHandler = (socket) ->
  socket.emit 'welcome'
  socket.on 'join', ({key}) ->
    boards[key] ||= new Board

    player = new Player socket
    boards[key].addPlayer player
    boards[key].startIfFull()
