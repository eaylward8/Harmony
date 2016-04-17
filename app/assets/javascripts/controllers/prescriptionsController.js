app.prescriptions = {
  controller: {
    new: function PrescriptionsController() {}
  }
};

app.prescriptions.controller.new.prototype.init = function() {
  $('#newPrescriptionButton').click(function(event) {
    event.preventDefault();
    $.ajax({
      url: '/prescriptions/new',
      method: 'GET'
    }).success(function(data) {
      $('#form-container').append(data);
      $('#form-submit').click(function(data) {
        $("#newPrescriptionModal").modal("hide");
        // $('#form-container').children().remove();
        // $('.pillbox-cell').remove();
      });
    });
  });
};