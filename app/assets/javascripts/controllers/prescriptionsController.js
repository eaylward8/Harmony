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
      $('#drug_name').focusout(function(){
        if ($('#drug_name').val().length > 0) {
          var drugName = $('#drug_name').val();
          $.ajax({
            url: '/prescriptions',
            method: 'POST',
            data: {drug_name: drugName}
          }).success(function(data) {
            var $submitBtn = $('#form-submit')
            if (data["validity"]) {
              $('#drug-valid-message').css('color', 'green').text('\u2714');
              $submitBtn.prop('disabled', false);
            } else {
              $('#drug-valid-message').css('color', 'red').text('Invalid drug name!');
              $submitBtn.prop('disabled', true);
            }
          });
        }
      });
      $(document).on('click', '#form-submit', function() {
        $("#newPrescriptionModal").modal("hide");
      });
    });
  });

  $(document).on('click', '.editPrescriptionButton', function(event) {
    var prescriptionId = parseInt(this.id.split("-")[1]);
      var formData = $('#edit_prescription_'+prescriptionId).serializeArray();
      $.ajax({
        url: '/prescriptions/'+prescriptionId,
        method: 'PATCH',
        data: formData
      }).success(function(data) {
        event.preventDefault();
        var doctor = new app.doctor.model.new(data.prescription.doctor.first_name, data.prescription.doctor.last_name, data.prescription.doctor.location, data.prescription.doctor.specialty, data.prescription.doctor.id)
        var user = new app.user.model.new(data.prescription.user.first_name, data.prescription.user.last_name, data.prescription.user.id)
        var pharmacy = new app.pharmacy.model.new(data.prescription.pharmacy.name, data.prescription.pharmacy.location, data.prescription.pharmacy.id)
        var drug = new app.drug.model.new(data.prescription.drug.name, data.prescription.drug.rxcui, data.prescription.drug.id)
        var prescription = new app.prescription.model.new(data.prescription.fill_duration, data.prescription.refills, data.prescription.start_date, data.prescription.dose_size, drug, doctor, pharmacy, user, data.prescription.id, data.prescription.end_date);
        
        $('.modal').modal('hide');
        $('.prescription-div-'+prescription.id).empty()
        $('.prescription-div-'+prescription.id).html(prescription.prescriptionEl())
      });
    event.preventDefault();
  });
  $('#exp-soon-table form').click(function(event) {
    event.preventDefault();
    var rxId = $(this).children('.btn').attr('data-rxid')
    $.ajax({
      url: '/prescriptions/' + rxId,
      method: 'PATCH',
      data: {refill: true}
    }).success(function(data) {
      if (data.expSoon && data.prescription.refills > 0) {
        //update exp date and refills
        var expDate = data.expDate;
        var refills = data.prescription.refills;
        var $expTd = $('tr[data-rxid='+data.prescription.id+'] td:nth-child(2) span'); 
        var $refillsTd = $('tr[data-rxid='+data.prescription.id+'] td:nth-child(3) span');
        $expTd.fadeOut(200, function() {
          $(this).text(expDate);
          $(this).fadeIn(200);
        });
        $refillsTd.fadeOut(200, function() {
          $(this).text(refills);
          $(this).fadeIn(200);
        });
      } else {
        // hide and remove row if new exp date is beyond 7 days
        var $tr = $('tr[data-rxid='+data.prescription.id+']');
        $tr.hide(300, function(){ $(this).remove() });
      }
    })
  })
};