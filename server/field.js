var Army = require('./army');
function Field(city,type){
	this.city = city;
	this.type = type;
	this.player = null;
	this.army = new Army(0,this.type);
};
Field.prototype.isCapital = function () {
	return this.city === 'capital'; 
};
Field.prototype.isCity = function () {
	return this.city !== null;
};
Field.prototype.isHarbor = function () {
	return this.city === 'harbor';
};

module.exports = Field;