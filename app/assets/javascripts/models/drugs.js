app.drug = {
  model: {
    all: [],
    new: (function () {
      var drug = function Drug(name, rxcui, id){
        this.name = name;
        this.rxcui = rxcui;
        this.id = id;
        app.drug.model.all.push(this);
      };
      return drug;
    }())
  }
}