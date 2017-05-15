var datetime_options = {
  format: I18n.t("datepicker.time.default"),
  enableOnReadonly: true,
  orientation: "auto",
  forceParse: false,
  daysOfWeekDisabled: "0,6",
  todayHighlight: true,
  showOnFocus: false
};

var btn_group = '<div class="btn-datepk" style="display: inline;">'
  + '<button class="btn btn-success btn-save">' + I18n.t("button.save")
  + '</button>' + '<button class="btn btn-danger btn-cancel" style="float: right;">'
  + I18n.t("button.cancel") + '</button></div>';

$(document).on('turbolinks:load ajaxComplete', function() {
  var select_date;
  $('input.datepicker').click(function() {
    var current_date = $(this).val();
    select_date = $(this).datepicker(datetime_options).datepicker('show');
    if($('.user-task-info').length > 0){
      $('.btn-datepk').remove();
      $('.datepicker-dropdown').append(btn_group);

      $('.btn-save').click(function() {
        select_date.parents('form').submit();
        select_date.datepicker('hide');
      });

      $('.btn-cancel').click(function() {
        select_date.datepicker('hide');
        cleardate(select_date);
      });

      select_date.datepicker().on('hide', function(e) {
        cleardate(this);
      });

      function cleardate(e) {
        $(e).val(current_date);
      }
    }
  });
});
