
app.user = {
  model: {
    all: [],
    new: (function () {
      var user = function User(first_name, last_name, id){
        this.first_name = first_name;
        this.last_name = last_name;
        this.id = id;
        app.user.model.all.push(this);
      };
      return user;
    }())  
  }
}