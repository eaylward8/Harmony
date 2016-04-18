app.users = {
  controller: {
    new: function UsersController() {}
  }
};

app.users.controller.new.prototype.init = function() {
  $(document).on('click', '#editUserProfileButton', function(event) {
    $('#user-modal').children().remove();
    event.preventDefault();
    $.ajax({
      url: '/users/' + userId + '/edit',
      method: 'GET'
    }).success(function(data) {
      $('#user-modal').append(data);
    });
  });
};