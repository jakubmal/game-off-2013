function Army(count,type){
	this.count = count;
	this.morale = count;
	this.type = type
};
Army.prototype.landing = function () {
	this.type = 'land';
}
Army.prototype.swim = function () {
	this.type = 'water'
}
module.exports = Army