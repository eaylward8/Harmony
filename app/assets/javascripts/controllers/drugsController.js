app.drugs = {
  controller: {
    new: function DrugsController() {}
  }
};

app.drugs.controller.new.prototype.init = function() {
  $(document).on('click', '.warning-icon', function() {
    $(this).parent().find('.warning-message').fadeIn(200);
  });
  $(document).on('click', '.warning-message', function() {
    $(this).fadeOut(200);
  });
};