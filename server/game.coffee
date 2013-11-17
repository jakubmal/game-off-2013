Board = require './board'
Player = require './player'

exports.show = (req, res) ->
  res.render 'show', key: req.query.key

boards = {}
exports.playerSocketHandler = (socket) ->
  socket.emit 'welcome'
  socket.on 'join', ({key}) ->
    console.log key
    boards[key] ||= new Board

    player = new Player socket
    boards[key].addPlayer player
    boards[key].startIfFull()
