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


$(document).on('click', '.editPrescriptionButton', function(event) {
  
  var prescriptionId = parseInt(this.id.split("-")[1]);
    // $('#form').children().remove();
    // event.preventDefault();
    
    // $.ajax({
    //   url: '/prescription/'+prescriptionId,
    //   method: 'PATCH'
    // }).success(function(data) {
    //   $('#form').append(data);
    //   $(document).on('click', '#form-submit', function(data) {
    //     $("#newPrescriptionModal").modal("hide");
    //   });
    // });
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