$(document).on('turbolinks:load ajaxComplete', function() {
  if ($('#user-subject').length > 0) {
    $('.btn-show').on('click', function() {
      var data = $(this).data('id');
      $(this).closest('tbody').find('.user-subject-' + data)
        .toggleClass('show-task');
      $('i', this).toggleClass('glyphicon-chevron-down glyphicon-chevron-up');
    });
  }
});
