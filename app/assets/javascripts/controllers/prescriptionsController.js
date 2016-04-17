app.prescriptions = {
  controller: {
    new: function PrescriptionsController() {}
  }
};

app.prescriptions.controller.new.prototype.init = function() {
  $(document).on('click', '#newPrescriptionButton', function(event) {
    $('#form').children().remove();
    event.preventDefault();
    $.ajax({
      url: '/prescriptions/new',
      method: 'GET'
    }).success(function(data) {
      $('#form').append(data);
      $(document).on('click', '#form-submit', function(data) {
        $("#newPrescriptionModal").modal("hide");
      });
    });
  });
};