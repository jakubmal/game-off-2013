var assert = require('assert');
var Board = require('../../server/board');
var Map = require('../../server/map');
var Player = require('../../server/player');


describe('Board',function (){
  var board = new Board();
  beforeEach(function (){
  	board = new Board();
  });
  it('should construct properly',function (){
	  board.map.should.be.instanceOf(Map);
	  assert.equal(board.currentPlayer,null);
	  board.players.should.have.lengthOf(0);
	  board.colors.should.have.lengthOf(4);
  });
  describe('.genPlayer',function (){
    it('should return; if PlAYER_LIMIT is exceeded',function (){
      var protoSocket = {emit:function(){}};
    	board.players.push(new Player({emit:function(){}},'color'));
    	board.players.push(new Player({emit:function(){}},'color'));
    	// board.players.push(new Player({emit:function(){}},'color'));
    	// board.players.push(new Player({emit:function(){}},'color'));

    	board.genPlayer(protoSocket);

    	board.players.should.have.lengthOf(2);//4
    });
    it('should generate players',function (){
      var socket = {emit:function(){}};
      var colors = ['red','green', 'blue','purple'];

      board.genPlayer(socket);
      board.genPlayer(socket);
      board.players.forEach(function (player){
        player.should.be.instanceOf(Player);
        player.color = colors.shift();
        player.should.have.property('onMakeMove');
        player.should.have.property('onEndTurn');
        player.should.have.property('onGiveSpeach');
        player.should.have.property('onDisconnect');
        player.should.have.property('onCountArmies');
      }); 
      board.players.should.have.lengthOf(2);//4
    });
  });
  // describe('.removePlayer',function (){
  //   it('should remove player',function (){
  //     var socket0 = {id:5,emit:function(){}};
  //     var socket1 = {id:6,emit:function(){}};

  //     board.genPlayer(socket0);
  //     board.genPlayer(socket1);
  //     var player = board.players[0];
  //     board.removePlayer(player);
  //     board.players.should.have.lengthOf(1);
  //   });
  // });
});