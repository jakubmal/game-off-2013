function mapGen(sizeX,sizeY,townCount,waterPercentage){
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.townCount = townCount;
    this.waterPercentage = waterPercentage;
    this.map = [];
}
mapGen.prototype._isInMap = function (x,y){
    return x>=0&&y>=0&&x<this.sizeX&&y<this.sizeY;
}
mapGen.prototype.getType = function (x,y){
  return this.map[x][y].type;
}
mapGen.prototype.getCity = function (x,y){
  return this.map[x][y].city;
}
mapGen.prototype.generate = function () {
  for(var i =0;i<this.sizeX;i++){
    this.map.push([]);
    for (var j = 0;j < this.sizeY ; j++) {
      this.map[i].push({type:'land',city: null});
    };
  }
  this.addWater(4);
  this.shouldNotBeWater(2,0);
  this.shouldNotBeWater(2,9);
  this.shouldNotBeWater(16,0);
  this.shouldNotBeWater(16,9);
  this.urbanize();
  return this.map;
}
mapGen.prototype.addWater = function (waterCount) {
  var waterX,waterY;
  for(var i = 0; i < waterCount;i++){
    waterX = Math.floor(Math.random()*(this.sizeX-1));
    waterY = Math.floor(Math.random()*(this.sizeY-1));
    this.map[waterX][waterY].type = 'water';
    this.expandWater(waterX,waterY,this.waterPercentage);
  }
}
mapGen.prototype.expandWater = function (waterX,waterY,localWaterPercentage) {
  this.expandWaterMagic(waterX-1,waterY,localWaterPercentage);
  this.expandWaterMagic(waterX+1,waterY,localWaterPercentage);
  this.expandWaterMagic(waterX,waterY+1,localWaterPercentage);
  this.expandWaterMagic(waterX+1,waterY+1,localWaterPercentage);
  this.expandWaterMagic(waterX+2,waterY,localWaterPercentage);
  this.expandWaterMagic(waterX-2,waterY,localWaterPercentage);
}
mapGen.prototype.expandWaterMagic = function(waterX,waterY,localWaterPercentage){
  if (localWaterPercentage < 0.01) {return;}
  if (localWaterPercentage > Math.random() && this._isInMap(waterX,waterY)) {
        this.map[waterX][waterY].type = 'water';
        localWaterPercentage = localWaterPercentage/1.5;
        this.expandWater(waterX,waterY);
    };
}
mapGen.prototype.shouldNotBeWater = function (x,y) { 
    this.map[x][y].type = 'land';
    this.map[x+1][y].type = 'land';
    this.map[x+1][y+1].type = 'land';
    this.map[x-1][y+1].type = 'land';
    this.map[x-1][y].type = 'land';
    this.map[x+2][y].type = 'land';
    this.map[x-2][y].type = 'land';
}
mapGen.prototype.addCities = function(borderXmin,borderXmax,borderYmin,borderYmax){
    var cityCount = Math.round(this.townCount/4);
    var citiesSet = 0,posX=0,posY0;
    var safetyBreakCounter = 0;
    while( citiesSet < cityCount && safetyBreakCounter < 10000 ){
        safetyBreakCounter++;
        posX = Math.floor(Math.random()*(borderXmax-borderXmin))+borderXmin;
        posY = Math.floor(Math.random()*(borderYmax-borderYmin))+borderYmin;
        // console.log('posx:'+posX+'posY'+posY);
        if(this._isInMap(posX,posY) && this.map[posX][posY].city == null && this.map[posX][posY].type == 'land' ){
            if(this.isHarbor(posX,posY)) this.map[posX][posY].city = 'harbor';
            else this.map[posX][posY].city = 'city';
            citiesSet++;
        }
    }
}
mapGen.prototype.urbanize = function(){
  var sqSizeX = Math.floor((this.sizeX-1)/2);
  var sqSizeY = Math.floor((this.sizeY-1)/2);
 
  this.addCities(0,sqSizeX,0,sqSizeY);
  this.addCities(sqSizeX,sqSizeX*2,0,sqSizeY);
  this.addCities(0,sqSizeX,sqSizeY,sqSizeY*2);
  this.addCities(sqSizeX,sqSizeX*2,sqSizeY,sqSizeY*2);   
};
mapGen.prototype.isHarbor = function (x,y){
  var neighbours = this.getNeighbours(x,y);
  var nX,nY;
  for (var i = 0; i < neighbours.length; i++){
    nX = neighbours[i].x;
    nY = neighbours[i].y;
    if(this.map[nX][nY].type === 'water') return true;
  };
  return false;
};

mapGen.prototype.getNeighbours = function (x,y){
  results = [];

  if(this._isInMap(x-2,y)) results.push({x: x-2,y:y});  
  if(this._isInMap(x+2,y)) results.push({x: x+2,y:y});  
  if(this._isInMap(x+1,y)) results.push({x: x+1,y:y}); 
  if(this._isInMap(x-1,y)) results.push({x: x-1,y:y});
  if(x%2 === 0){ 
    if(this._isInMap(x-1,y+1)) results.push({x: x-1,y:y+1}); 
    if(this._isInMap(x+1,y+1)) results.push({x: x+1,y:y+1});
  }else{
    if(this._isInMap(x-1,y-1)) results.push({x: x-1,y:y-1}); 
    if(this._isInMap(x+1,y-1)) results.push({x: x+1,y:y-1});
  } 
   return  results;
}

module.exports = mapGen;