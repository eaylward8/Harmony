
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

      user.prototype.refillRowEl = function() {
        //return '<tr><td>' '</td><td></td><td></td></tr>'
          // <tr>
          //   <td><%= rx.drug.name %></td>
          //   <td><%= rx.format_date(rx.end_date) %>
          //   <td><%= rx.refills %></td>
          // <% end %></tr>'
      };      
      user.prototype.build = function() {
         $('#prescriptions').append(this.prescriptionEl());
         // $('#task_prescription_id').append(this.optionEl());
      };
      return user;
    }())  
  }
};