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
  var prescriptionsController = new app.prescriptions.controller.new();
  prescriptionsController.init();
  var usersController = new app.users.controller.new();
  usersController.init();
  // creating new  prescription controller
  // prescriptionController = new app.prescription.controller.new();

  }); // ends document ready
