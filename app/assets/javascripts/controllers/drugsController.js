app.drugs = {
  controller: {
    new: function DrugsController() {}
  }
};

app.drugs.controller.new.prototype.init = function() {
  $('.warning-icon').mouseenter(function() {
    $(this).parent().find('.warning-message').fadeIn(100);
  });
  $('.warning-icon').mouseleave(function() {
    $(this).parent().find('.warning-message').fadeOut(100);
  });
};