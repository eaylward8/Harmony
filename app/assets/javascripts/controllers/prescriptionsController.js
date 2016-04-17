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

  // $(document).on('click', '.editPrescriptionButton', function(event) {
  //   // $('#form').children().remove();
  //   event.preventDefault();
  //   var prescriptionId = parseInt(this.id.split("-")[1]);
  //   var prescription = Prescripton.findBy(prescriptionId);
    
  //   $.ajax({
  //     url: '/prescriptions/'+prescriptionId+'/edit',
  //     method: 'GET',
  //     data: prescriptionId
  //   }).success(function(data) {
  //     $('#form').append(data);
  //     $(document).on('click', '#form-submit', function(data) {
  //       $("#editPrescriptionModal").modal("hide");
  //     });
  //   });
  // });

};