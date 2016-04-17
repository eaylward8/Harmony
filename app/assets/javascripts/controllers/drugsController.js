app.drugs = {
  controller: {
    new: function DrugsController() {}
  }
};

app.drugs.controller.new.prototype.init = function() {
  $(document).on('mouseenter', '.warning-icon', function() {
    $(this).parent().find('.warning-message').fadeIn(100);
  });
  $(document).on('mouseleave', '.warning-icon', function() {
    $(this).parent().find('.warning-message').fadeOut(100);
  });
};