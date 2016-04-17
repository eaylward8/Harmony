app.prescriptions = {
  controller: {
    new: function PrescriptionsController() {}
  }
};

app.prescriptions.controller.new.prototype.init = function() {
  $(document).on('click', '#newPrescriptionButton', function(event) {
    event.preventDefault();
    $.ajax({
      url: '/prescriptions/new',
      method: 'GET'
    }).success(function(data) {
      $('#form-container').append(data);
      $(document).on('click', '#form-submit', function(data) {
        $("#newPrescriptionModal").modal("hide");
        // $('#form-container').children().remove();
      });
    });
  });
};