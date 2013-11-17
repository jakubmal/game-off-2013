
/**
 * Module dependencies.
 */

require('coffee-script');

var express = require('express');
var game = require('./server/game');
var http = require('http');
var path = require('path');

var app = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(app.router);
app.use(require('less-middleware')({ src: path.join(__dirname, 'public') }));
app.use(require('coffee-middleware')({ src: path.join(__dirname, 'client') }));
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'client')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

app.get('/game', game.show);
app.get('/get_map', game.getMap);
app.get('/games', game.index);

var server = http.createServer(app);
var io = require('socket.io').listen(server);
io.sockets.on('connection', game.playerSocketHandler);

server.listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
