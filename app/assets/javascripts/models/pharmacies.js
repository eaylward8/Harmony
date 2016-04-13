
app.drug = {
  model: {
    all: [],
    new: (function () {
      var drug = function Drug(name, rxcui){
        this.name = name;
        this.rxcui = rxcui;
      };
    })  
  }
}