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
//= require turbolinks
//= require_tree 
//= require models/prescriptions.js

$(function() {
  // document ready

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
    for (var i = 0; i < data.prescriptions.length; i++) {
      debugger
      // populating data 
      // create the four objects below
      // var doctor
      // var user
      // var pharmacy
      // var drug 
      // use the four objects to make a prescription
      var prescription = new app.prescription.model.new(data.prescriptions[i].fill_duration, data.prescriptions[i].refills, data.prescriptions[i].start_date, data.prescriptions[i].dose_size, drug, doctor, pharmacy, user);
      // make a build function for adding new scripts
      prescription.build();
    };

  })
})
