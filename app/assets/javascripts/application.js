// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree
//= require models/prescriptions.js
//= require models/doctors.js
//= require models/users.js
//= require models/pharmacies.js
//= require models/drugs.js

$(function() {
  var drugsController = new app.drugs.controller.new();
  drugsController.init();
  // document ready
  var prescriptionController = new app.prescription.controller.new();
  prescriptionController.init();
  // creating new  prescription controller
  // prescriptionController = new app.prescription.controller.new();

  // setting up listeners
  // prescriptionController.init();

  // getting data from rails to populate
  $.ajax({
    //  get all the user's prescriptions
    url: '/prescriptionsjson/',
    method: 'GET', 

    // clearing out the divss
  }).success(function (data) {

    $('#prescriptions').empty();
    // $('#task_list_id').empty();
    if (data.prescriptions.length ===0) {
      $('prescriptions').append("<div class='prescription'><h2>You have no active prescriptions</h2></div>");
    } else {


    for (var i = 0; i < data.prescriptions.length; i++) {
      
      // populating data 
      // create the four objects below
      var doctor = new app.doctor.model.new(data.prescriptions[i].doctor.first_name, data.prescriptions[i].doctor.last_name, data.prescriptions[i].doctor.location, data.prescriptions[i].doctor.specialty, data.prescriptions[i].doctor.id)
      var user = new app.user.model.new(data.prescriptions[i].user.first_name, data.prescriptions[i].user.last_name, data.prescriptions[i].user.id)
      var pharmacy = new app.pharmacy.model.new(data.prescriptions[i].pharmacy.name, data.prescriptions[i].pharmacy.location, data.prescriptions[i].pharmacy.id)
      var drug = new app.drug.model.new(data.prescriptions[i].drug.name, data.prescriptions[i].drug.rxcui, data.prescriptions[i].drug.id)

      // use the four objects to make a prescription
      var prescription = new app.prescription.model.new(data.prescriptions[i].fill_duration, data.prescriptions[i].refills, data.prescriptions[i].start_date, data.prescriptions[i].dose_size, drug, doctor, pharmacy, user, data.prescriptions[i].id, data.prescriptions[i].end_date);
      // make a build function for adding new scripts
      prescription.build();
      }
    };
    
  })
})
