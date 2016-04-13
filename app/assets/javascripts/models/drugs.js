
app.drug = {
  model: {
    all: [],
    new: (function () {
      var drug = function Drug(name, rxcui){
        this.name = name;
        this.rxcui = rxcui;
        app.drug.model.all.push(this);
      };
      return drug;
    }())
  }
}