
app.pharmacy = {
  model: {
    all: [],
    new: (function () {
      var pharmacy = function Pharmacy(name, location){
        this.name = name;
        this.location = location;
        app.pharmacy.model.all.push(this);
      };
      return pharmacy;
    }())  
  }
}