var terrainGen = require('./mapTerrainGen');
function mapGen(){
}

mapGen.prototype.getLand = function (i,j){
    return this.map[i][j].type;
}
mapGen.prototype.getCity = function (i,j){
    return this.map[i][j].isCity;
}

mapGen.prototype.generate = function (sizeX,sizeY) {
var terrainMap = terrainGen(32,1,30);
this.map = [sizeX];
  for(var i =0;i<sizeX;i++){
    this.map[i] = [sizeY];
    for (var j = 0;j < sizeY ; j++) {
      if(terrainMap[i][j] == 1){
        this.map[i][j] = {type:'land',isCity : false};
        }else{
        this.map[i][j] = {type:'water',isCity : false};
        }
    };
  }
  this._landNearCapitol();
  this.addCities(sizeX,sizeY);
  return this.map;
}
mapGen.prototype._landNearCapitol = function () {

    this.map[1][1].type = 'land';
    this.map[1][2].type = 'land';
    this.map[2][1].type = 'land';
    this.map[2][2].type = 'land';

    this.map[18][1].type = 'land';
    this.map[17][1].type = 'land';
    this.map[18][2].type = 'land';
    this.map[17][2].type = 'land';

    this.map[1][10].type = 'land';
    this.map[1][9].type = 'land';
    this.map[2][9].type = 'land';
    this.map[2][10].type = 'land';

    this.map[18][10].type = 'land';
    this.map[18][9].type = 'land';
    this.map[17][9].type = 'land';
    this.map[17][10].type = 'land';

}
mapGen.prototype.addCities = function(sizeX,sizeY){
    // generate 8 towns per square
    var sqSizeX = Math.floor((sizeX-1)/2);
    var sqSizeY = Math.floor((sizeY-1)/2);
    var cityCount = 8;
    var citiesSet = 0,posX,posY;
    // 1 sq
    while( citiesSet < cityCount ){
        posX = Math.floor(Math.random()*sqSizeX);
        posY = Math.floor(Math.random()*sqSizeY);  
        if(this.map[posX][posY].isCity == false && this.map[posX][posY].type == 'land' ){
            this.map[posX][posY].isCity = true;
            citiesSet++;
        }
    }
    // 2 sq
    citiesSet = 0;
    while( citiesSet < cityCount ){
        posX = Math.floor(Math.random()*sqSizeX)+sqSizeX;
        posY = Math.floor(Math.random()*sqSizeY);   
        if(this.map[posX][posY].isCity == false && this.map[posX][posY].type == 'land'){
            this.map[posX][posY].isCity = true;
            citiesSet++;
        }
    }
    // 3 sq
     citiesSet = 0;
    while( citiesSet < cityCount ){
        posX = Math.floor(Math.random()*sqSizeX);
        posY = Math.floor(Math.random()*sqSizeY)+sqSizeY;   
        if(this.map[posX][posY].isCity == false  && this.map[posX][posY].type == 'land'){
            this.map[posX][posY].isCity = true;
            citiesSet++;
        }
    }
    //4 sq
     citiesSet = 0;
    while( citiesSet < cityCount ){
        posX = Math.floor(Math.random()*sqSizeX)+sqSizeX;
        posY = Math.floor(Math.random()*sqSizeY)+sqSizeY;   
        if(this.map[posX][posY].isCity == false  && this.map[posX][posY].type == 'land'){
            this.map[posX][posY].isCity = true;
            citiesSet++;
        }
    }

}

module.exports = mapGen;
