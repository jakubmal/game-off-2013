var assert = require('assert');
var should = require('should');

var Army = require('../../server/army');

describe('Army',function (){
  describe('normalize',function (){
      it('ensures morale and count are below 99',function (){
        var army = new Army(10,'land');

        army.count += 100;
        army.morale += 100;
        army.normalize();

        assert.equal(army.count,99);
        assert.equal(army.morale,99);

        army.count -= 200;
        army.morale -= 200;
        army.normalize();

        assert.equal(army.count,0);
        assert.equal(army.morale,0);
    });
  });
  
  describe('getPower',function(){
    it("calculates army's power",function (){
      var armies = [];
      var powers = [];
      var demoralizedArmy = new Army(10,'land');

      for (var i = 0; i < 10; i++) {
        armies.push(new Army(i,'land'));
        powers.push(armies[i].getPower());
      };

      for (var i = 0; i < 10; i++) {
        assert.equal(powers[i],10*i);
      };

      demoralizedArmy.morale = 0;
      assert.equal(demoralizedArmy.getPower(),0);
    });
  });

  describe('fight',function (){
    it("calculates army's count and morale after fighting enemy",function (){
      var army = [];
      var enemy = [];
      var output = [];
      var bigger = new Army(50,'land');
      var smaller = new Army(10,'land');

      for(var i = 0; i < 12;i++){
        army.push(new Army(30,'land'));
        enemy.push(new Army(3*i,'land'));
        army[i].fight(enemy[i]);
      };

      for (var i = 0; i < 10; i++) {
        assert.equal(army[i].count,30-3*i);
        assert.equal(army[i].morale,14)     
      };

      assert.equal(army[10].count,1);
      assert.equal(army[10].morale,14);
      assert.equal(army[11].count,0);

      // shouldn't happen, bigger.fight(smaller) would be called instead
      smaller.fight(bigger);
      assert.equal(smaller.count,0);

    });
  });

  describe('join',function (){
    it('joins two armies, that have the same owner',function () {
      var armies = [];
      var demoralizedArmy = new Army(10,'land');
      var noArmy = new Army(0,'land');


      for(var i=0; i < 20;i++){
        armies.push(new Army(i,'water'));
        armies[i].morale = 10+i;
      }
      for(var i=0; i < 19;i++){
        armies[i].join(armies[(i+1)%20]);
      }

      for (var i = 0; i < 19; i++) {
        assert.equal(armies[i].count,2*i+1);
        assert.equal(armies[i].morale,i+11);
      };

      armies[19].join(noArmy);
      assert.equal(armies[19].count,19);
      assert.equal(armies[19].morale,10+19);

      demoralizedArmy.morale = 0;
      demoralizedArmy.join(armies[19]);

      assert.equal(demoralizedArmy.count,10+19);
      assert.equal(demoralizedArmy.morale,19);

    });
  });
  describe('learnFromTravel',function (){
    it('It increases morale after moving', function (){
      var army = new Army(80,'land');

      army.morale = 96;
      army.learnFromTravel();
      assert.equal(army.morale,98);

      army.learnFromTravel();
      assert.equal(army.morale,99);
    });
  });
});