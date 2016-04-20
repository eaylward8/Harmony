app.pharmacy = {
  model: {
    all: [],
    new: (function () {
      var pharmacy = function Pharmacy(name, location, id){
        this.name = name;
        this.location = location;
        this.id = id;
        app.pharmacy.model.all.push(this);
      };
      return pharmacy;
    }())  
  }
}