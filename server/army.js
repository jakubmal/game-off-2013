
var MAX_ARMY_COUNT = 99;
var MAX_ARMY_MORALE = 99;
var DEFAULT_MORALE = 10;
var MORALE_FOR_WINNING = 4;
var MORALE_FOR_MOVING = 2;

function Army(count,type){
	this.count = count;
	this.morale = DEFAULT_MORALE;
	this.type = type
};
Army.prototype.landing = function () {
	this.type = 'land';
}
Army.prototype.swim = function () {
	this.type = 'water'
}
Army.prototype.normalize = function () {
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
Army.prototype.die = function () {
	this.morale = DEFAULT_MORALE;
	this.count = 0;
}
Army.prototype.fight = function (enemy){
	this.count = Math.round((this.getPower() - enemy.getPower())/this.morale);
	this.morale += MORALE_FOR_WINNING;
}
Army.prototype.join = function (otherArmy){
	this.morale = Math.round((this.getPower()+otherArmy.getPower())/(this.count+otherArmy.count));
	this.count += otherArmy.count;
	this.morale += MORALE_FOR_MOVING; // Travel broadens the mind
	if(this.player === null){
		this.player = otherArmy.player;
		this.morale -= DEFAULT_MORALE; // because every unoccupied Field has morale =  DEFAULT_MORALE 
	}
}
module.exports = Army