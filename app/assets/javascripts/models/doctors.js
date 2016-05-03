app.doctor = {
  model: {
    all: [],
    new: (function() {
      var doctor = function Doctor(id, first_name, last_name, location, specialty){
        this.id = id;
        this.first_name = first_name;
        this.last_name = last_name;
        this.location = location;
        this.specialty = specialty;
        app.doctor.model.all.push(this);
      };
      return doctor;
    }())
  }
};