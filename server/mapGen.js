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
  return this.map[x][y].isCity;
}

mapGen.prototype.generate = function () {
  for(var i =0;i<this.sizeX;i++){
    this.map.push([]);
    for (var j = 0;j < this.sizeY ; j++) {
      this.map[i].push({type:'land',isCity : false});
    };
  }
  this.addWater(4);
  this.shouldNotBeWater(2,0);
  this.shouldNotBeWater(2,9);
  this.shouldNotBeWater(16,0);
  this.shouldNotBeWater(16,9);
  this.addCities();
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
mapGen.prototype.addCities = function(){
    var sqSizeX = Math.floor((this.sizeX-1)/2);
    var sqSizeY = Math.floor((this.sizeY-1)/2);
    var cityCount = Math.round(this.townCount/4);
    var citiesSet = 0,posX,posY;
    var breakCounter = 0;
    // 1 sq
    while( citiesSet < cityCount && breakCounter < 10000 ){
        breakCounter++;
        posX = Math.floor(Math.random()*sqSizeX);
        posY = Math.floor(Math.random()*sqSizeY);
        if(this.map[posX][posY].isCity == false && this.map[posX][posY].type == 'land' ){
            this.map[posX][posY].isCity = true;
            citiesSet++;
        }
    }
    // 2 sq
    citiesSet = 0;
    while( citiesSet < cityCount && breakCounter < 10000 ){
              breakCounter++;
        posX = Math.floor(Math.random()*sqSizeX)+sqSizeX;
        posY = Math.floor(Math.random()*sqSizeY);
        if(this.map[posX][posY].isCity == false && this.map[posX][posY].type == 'land'){
            this.map[posX][posY].isCity = true;
            citiesSet++;
        }
    }
    // 3 sq
     citiesSet = 0;
    while( citiesSet < cityCount && breakCounter < 10000 ){
              breakCounter++;
        posX = Math.floor(Math.random()*sqSizeX);
        posY = Math.floor(Math.random()*sqSizeY)+sqSizeY;
        if(this.map[posX][posY].isCity == false  && this.map[posX][posY].type == 'land'){
            this.map[posX][posY].isCity = true;
            citiesSet++;
        }
    }
    //4 sq
     citiesSet = 0;
    while( citiesSet < cityCount && breakCounter < 10000 ){
        breakCounter++;
        posX = Math.floor(Math.random()*sqSizeX)+sqSizeX;
        posY = Math.floor(Math.random()*sqSizeY)+sqSizeY;
        if(this.map[posX][posY].isCity == false  && this.map[posX][posY].type == 'land'){
            this.map[posX][posY].isCity = true;
            citiesSet++;
        }
    }

}

module.exports = mapGen;
