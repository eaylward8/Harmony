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
      $('#new_prescription').on('submit', function(event) {
        event.preventDefault();
        var formData = ($(this).serialize());
        $.ajax({
          url: '/prescriptions',
          method: 'POST',
          data: formData
        }).success(function(data) {

        });
        $("#newPrescriptionModal").modal("hide");
      });
    });
  });
  
  // event handling for refill buttons
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