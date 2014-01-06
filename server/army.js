
var MAX_ARMY_COUNT = 99;
var MAX_ARMY_MORALE = 99;
var DEFAULT_MORALE = 10;
var MORALE_FOR_WINNING = 4;
var MORALE_FOR_MOVING = 2;

function Army(count,type){
	this.count = count;
	this.morale = DEFAULT_MORALE;
	this.type = type
	this.moved = false;
};
Army.prototype.landing = function () {
	this.type = 'land';
}
Army.prototype.swim = function () {
	this.type = 'water'
}
Army.prototype.normalize = function () {
	if(this.count < 0){
		this.count = 0;
		console.log('Error: count below 0');
	}
	if(this.morale < 0){
		this.morale = 0;
		console.log('Error: morale below 0');
	}
	if(this.count > MAX_ARMY_COUNT ){
		this.count = MAX_ARMY_COUNT;
	}
	if(this.morale > MAX_ARMY_MORALE){
		this.morale = MAX_ARMY_MORALE;
	}
}
Army.prototype.getPower = function () {
	return this.morale*this.count;
}
Army.prototype.fight = function (enemy){
	var powerDiff = this.getPower() - enemy.getPower()
	this.count = Math.round(powerDiff/this.morale);
	this.morale += MORALE_FOR_WINNING;
	if(this.count === 0) this.count++;
	this.normalize();
}
Army.prototype.join = function (otherArmy){
	var powerSum = this.getPower()+otherArmy.getPower()
	this.count += otherArmy.count;
	this.morale = Math.round(powerSum/this.count);
	this.normalize();
}
Army.prototype.learnFromTravel = function(){
	this.morale += MORALE_FOR_MOVING;
	this.normalize()
}
module.exports = Army