var assert = require('assert');
var should = require('should');

var Field = require('../../server/field');

describe('Field',function (){
  describe('.isCity',function (){
    it('Harbor and capital are also cities',function (){
      var harbor = new Field('harbor','land');
	  var capital = new Field('capital','land');
      var city = new Field ('city','land');

	  assert.equal(city.isCity(),true);
	  assert.equal(harbor.isCity(),true);
	  assert.equal(capital.isCity(),true);
	});
  });
});