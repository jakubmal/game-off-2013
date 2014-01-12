var assert = require('assert');
var should = require('should');
var _ = require('underscore');
var Map = require('../../server/map');
var Field = require('../../server/field');
var Player = require('../../server/player');
var Army = require('../../server/army');

describe('Map',function (){
  it('should exist & construct properly',function(){
	  var map = new Map();
	  _.flatten(map.fields).forEach(function (f){
		f.should.be.instanceOf(Field);
	  });
	  for(var i = 0; i < 19;i++){
	  	if(i%2 === 0){
	  	  map.fields[i].should.have.lengthOf(10)
	  	}else{
	  	  map.fields[i].should.have.lengthOf(11)
	  	}
	  }
  });
  describe('.initCapitals',function (){
  	it('should initialize capitals',function (){
      var map = new Map();
      var colors = ['red', 'green', 'blue', 'purple'];
      var players = [];

      colors.forEach(function (color){
      	players.push(new Player({socket:'thisIsSocket',emit:function(){}},color));
      });

      map.initCapitals(players);

      assert.deepEqual(map.fields[2][0].player,players[0]);
      assert.equal(map.fields[2][0].city,'capital');

      assert.deepEqual(map.fields[16][9].player,players[1]);
      assert.equal(map.fields[16][9].city,'capital');

      // commented at player.coffee for dev purposes
      // assert.deepEqual(map.fields[16][0].player,players[2]);
      // assert.equal(map.fields[16][0].city,'capital');

      // assert.deepEqual(map.fields[2][9].player,players[3]);
      // assert.equal(map.fields[2][9].city,'capital');
  	});
  });
  describe('.getNeighbours',function(){
    it('should return correct number of neighbours for map corners',function (){
      var map = new Map();
      var coords = [];

      coords.push({x:0,y:0});// left top
      coords.push({x:1,y:0});// left top
      coords.push({x:1,y:10});// right top
      coords.push({x:0,y:9});// right top
      coords.push({x:17,y:10});// right bottom
      coords.push({x:18,y:9});// right bottom
      coords.push({x:17,y:0});// left bottom
      coords.push({x:18,y:0});// left bottom

      coords.forEach(function (coord){
        map.getNeighbours(coord).should.have.lengthOf(3);
      });
    });
    it('should return correct number of neighbours for top border',function (){
      var map = new Map();
      var coordsEven = [];
      var coordsOdd = [];

      for(var i = 0; i < 10;i++)coordsEven.push({x:0,y:i});
      for(var i = 1; i < 10;i++)coordsOdd.push({x:1,y:i});

      coordsEven.forEach(function (coord){
        map.getNeighbours(coord).should.have.lengthOf(3);
      });
      coordsOdd.forEach(function (coord){
        map.getNeighbours(coord).should.have.lengthOf(5);
      });
    });
    it('should return correct number of neighbours for right border',function (){
      var map = new Map();
      var coords = [];

      for(var i = 1; i < 8 ;i++)coords.push({x:2*i+1,y:10});
      coords.forEach(function (coord){
        map.getNeighbours(coord).should.have.lengthOf(4);
      });
    });
    it('should return correct number of neighbours for bottom border',function (){
      var map = new Map();
      var coordsEven = [];
      var coordsOdd = [];

      for(var i = 0; i < 10;i++)coordsEven.push({x:18,y:i});
      for(var i = 1; i < 10;i++)coordsOdd.push({x:17,y:i});

      coordsEven.forEach(function (coord){
        map.getNeighbours(coord).should.have.lengthOf(3);
      });
      coordsOdd.forEach(function (coord){
        map.getNeighbours(coord).should.have.lengthOf(5);
      });
    });
    it('should return correct number of neighbours for left border',function (){
      var map = new Map();
      var coords = [];

      for(var i = 1; i < 8 ;i++)coords.push({x:2*i+1,y:0});
      coords.forEach(function (coord){
        map.getNeighbours(coord).should.have.lengthOf(4);
      });
    });
    it('should return correct number of neighbours for map center',function (){
      var map = new Map();
      var coords = [];

      coords.push({x:10,y:7});
      coords.push({x:9,y:3});
      coords.push({x:3,y:7});
      coords.push({x:16,y:0});
      coords.push({x:6,y:0});
      coords.push({x:10,y:8});

      coords.forEach(function (coord){
        map.getNeighbours(coord).should.have.lengthOf(6);
      });
    });
  });
  describe('.isInMap',function (){
  	it('should check if field is in the map',function (){
  	  var map = new Map();

	  map.isInMap({x:0,y:0}).should.be.ok;
	  map.isInMap({x:1,y:1}).should.be.ok;
	  map.isInMap({x:18,y:9}).should.be.ok;
	  map.isInMap({x:17,y:10}).should.be.ok;
	  map.isInMap({x:18,y:11}).should.not.be.ok;
	  map.isInMap({x:19,y:10}).should.not.be.ok;
  	});
  });
  describe('.countArmies',function (){
    it('should return number of owned armies ',function (){
      var map = new Map();
      var armiesCoord = [];
      var playerRed = new Player({socket:'thisIsSocket',emit:function(){}},'red');
      var playerPurple = new Player({socket:'thisIsSocket',emit:function(){}},'purple');

      armiesCoord.push({x:1,y:1});
      armiesCoord.push({x:3,y:5});
      armiesCoord.push({x:11,y:7});
      armiesCoord.push({x:0,y:1});
      armiesCoord.push({x:8,y:8});
      armiesCoord.push({x:15,y:1});
      armiesCoord.push({x:6,y:4});

      armiesCoord.forEach( function (coord){
        map.fields[coord.x][coord.y].army = new Army(10,'land');
        map.fields[coord.x][coord.y].player = playerRed;
      });
      //other player
      armiesCoord.forEach( function (coord){
        map.fields[coord.x+1][coord.y+1].army = new Army(10,'land');
        map.fields[coord.x+1][coord.y+1].player = playerPurple;
      });

      map.countArmies(playerRed).should.be.equal(armiesCoord.length);
      map.fields[0][1].army = null;
      map.countArmies(playerRed).should.be.equal(armiesCoord.length-1);
      map.countArmies(playerPurple).should.be.equal(armiesCoord.length);
      map.fields[7][5].army = null;
      map.countArmies(playerRed).should.be.equal(armiesCoord.length-1);
      map.countArmies(playerPurple).should.be.equal(armiesCoord.length-1);
    });
  });
  describe('.removeArmies',function (){
    it('should remove armies after player lost',function (){
      var map = new Map();
      var armiesCoord = [];
      var playerRed = new Player({socket:'thisIsSocket',emit:function(){}},'red');
      var playerPurple = new Player({socket:'thisIsSocket',emit:function(){}},'purple');

      armiesCoord.push({x:1,y:1});
      armiesCoord.push({x:3,y:5});
      armiesCoord.push({x:11,y:7});
      armiesCoord.push({x:0,y:1});
      armiesCoord.push({x:8,y:8});
      armiesCoord.push({x:15,y:1});
      armiesCoord.push({x:6,y:4});

      armiesCoord.forEach( function (coord){
        map.fields[coord.x][coord.y].army = new Army(10,'land');
        map.fields[coord.x][coord.y].player = playerRed;
      });
      //other player
      armiesCoord.forEach( function (coord){
        map.fields[coord.x+1][coord.y+1].army = new Army(10,'land');
        map.fields[coord.x+1][coord.y+1].player = playerPurple;
      });

      map.countArmies(playerRed).should.be.equal(armiesCoord.length);
      map.removeArmies(playerRed); 
      map.countArmies(playerRed).should.be.equal(0);
      map.countArmies(playerPurple).should.be.equal(armiesCoord.length);

      armiesCoord.forEach( function (coord){
        assert.equal(map.fields[coord.x][coord.y].army,null);
        assert.equal(map.fields[coord.x][coord.y].player,null);
      });
      
    });
  });
  describe('.giveSpeach',function (){
    it('should double all player armies morale',function (){
      var map = new Map();
      var player = new Player({socket:'thisIsSocket',emit:function(){}},'red');
      var player2 = new Player({socket:'thisIsSocket',emit:function(){}},'purple');
      var randomFields = [];
      var startingMorale = 10;
      
      for (var i = 0; i < 20; i++) {
        randomFields.push({x:Math.floor(Math.random()*18),y:Math.floor(Math.random()*10)});
      };

      randomFields.forEach(function (coord){
        map.fields[coord.x][coord.y].army = new Army(10,'land');
        map.fields[coord.x][coord.y].player = player;
      });

      map.fields[8][8].army = new Army(10,'land');
      map.fields[8][8].player = player2;
      map.giveSpeach(player);

      randomFields.forEach(function (coord){
        if(coord.x ==8 && coord.y == 8) return;
        map.fields[coord.x][coord.y].army.morale.should.be.equal(2*startingMorale);
      });

      map.fields[8][8].army.morale.should.be.equal(startingMorale);
    });
  });
  describe('.genArmies',function (){
    it("should create an army in city if there isn't one",function (){
      var map = new Map();
      var player = new Player({socket:'thisIsSocket',emit:function(){}},'red');
      var checkGen = function(x,y,cityType,player,expectedArmyCount){
        var city = map.fields[x][y];

        city.city = cityType;
        city.army = null;
        city.player = player;
        map.genArmies();

        city.army.should.be.instanceOf(Army);
        city.army.count.should.be.equal(expectedArmyCount+1);// because of 1 owned field
        city.army = null;
        city.player = null;
      }
      checkGen(2,9,'capital',player,15);
      checkGen(5,7,'harbor',player,5);
      checkGen(12,4,'city',player,5);
    });
    it('should increase army.count if there is an army in city',function (){
      var map = new Map();
      var player = new Player({socket:'thisIsSocket',emit:function(){}},'red');
      var checkGen = function(x,y,cityType,player,expectedArmyCount){
        var city = map.fields[x][y];
        city.army = new Army(25,'land');
        city.city = cityType;
        city.player = player;
        map.genArmies();

        city.army.should.be.instanceOf(Army);
        city.army.count.should.be.equal(expectedArmyCount+1);// because of 1 owned field
        city.army = null;
        city.player = null;
      }
      checkGen(2,9,'capital',player,40);
      checkGen(5,7,'harbor',player,30);
      checkGen(12,4,'city',player,30);

      map.fields[5][8].army = new Army(99,'land');
      map.fields[5][8].city = 'city';
      map.fields[5][8].player = player;
      map.genArmies();

      map.fields[5][8].army.count.should.be.equal(99);
    });
  });
  describe('.assignNeighboursTo',function (){
    it('should make player owner of surrounding fields',function (){
      var map = new Map();
      var player = new Player({socket:'thisIsSocket',emit:function(){}},'red');
      var coords = [];
      var neighbours = [];

      coords.push({x:1,y:1});
      coords.push({x:3,y:5});
      coords.push({x:11,y:7});
      coords.push({x:0,y:1});
      coords.push({x:8,y:8});
      coords.push({x:15,y:1});
      coords.push({x:6,y:4});

      coords.forEach(function (coord){
        neighbours.push(map.getNeighbours(coord).filter(function (field){
          return field.type === 'land' && field.city === null;
        }));
      });
      _.flatten(neighbours).forEach(function (field){
        field.player.should.be.equal(player);
      });
    });
    it("shouldn't make player owner of surrounding water and cities",function (){
      var map = new Map();
      var player = new Player({socket:'thisIsSocket',emit:function(){}},'red');
      var coords = [];
      var waterOrCityNeighbours = [];

      coords.push({x:1,y:1});
      coords.push({x:3,y:5});
      coords.push({x:11,y:7});
      coords.push({x:0,y:1});
      coords.push({x:8,y:8});
      coords.push({x:15,y:1});
      coords.push({x:6,y:4});

      coords.forEach(function (coord){
        waterOrCityNeighbours.push(map.getNeighbours(coord).filter(function (field){
          return field.type === 'water' || field.city != null;
        }));
      });
      coords.forEach(function (coord){
        map.assignNeighboursTo(coord,player);
      });

      _.flatten(waterOrCityNeighbours).forEach(function (field){
        field.player.should.not.be.equal(player);
      });
    });
  });
  describe('.makeMove',function (){
    var map = new Map();
    var player = new Player({socket:'thisIsSocket',emit:function(){}},'red');

    map.fields[5][4].army = new Army(10,'land');
    map.fields[5][4].player = player;
    map.makeMove({x:5,y:4},{x:6,y:4});
    it('should destroy army in sourceField',function (){
      assert.equal(map.fields[5][4].army,null);
    });
    it('should move army to dest field',function (){
      map.fields[6][4].player.should.be.equal(player);
      map.fields[6][4].army.should.be.instanceOf(Army);
      map.fields[6][4].army.count.should.be.equal(10);
    });
    it('should join armies if fields owned by the same player',function (){
      map.fields[5][6].army = new Army(20,'land');
      map.fields[5][6].player = player;
      var army1 = new Army(10,'land');
      var army2 = new Army(20,'land');

      army1.join(army2);
      map.makeMove({x:6,y:4},{x:5,y:6});

      map.fields[5][6].army.should.eql(army1);
      map.fields[5][6].player.should.be.equal(player);
    });
    it('should fight armies if owned by 2 players',function (){
      map.fields[5][6].army = new Army(10,'land');
      map.fields[5][6].player = {what:'ever'};
      map.fields[6][4].army = new Army(20,'land');
      map.fields[6][4].player = player;
      var army1 = new Army(10,'land');
      var army2 = new Army(20,'land');

      army2.fight(army1);
      map.makeMove({x:6,y:4},{x:5,y:6});

      map.fields[5][6].army.should.eql(army2);
      map.fields[5][6].player.should.be.equal(player);
    });
  });
});