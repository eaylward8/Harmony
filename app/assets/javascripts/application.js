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

  // shows time of day indicator on dashboard view
  (function showTimeIndicator() {
    var today = new Date;
    var hour = today.getHours();
// erik move
  //   if (hour >= 5 && hour < 12) {
  //     $('#morning-time').text('\u25b2');
  //   } else if (hour >= 12 && hour < 17) {
  //     $('#afternoon-time').text('\u25b2');
  //   } else if (hour >= 17 && hour < 21) {
  //     $('#evening-time').text('\u25b2');
  //   } else if (hour >= 21 || hour < 5) {
  //     $('#night-time').text('\u25b2');
  //   }
  }())

}); // ends document ready
