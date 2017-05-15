$(document).on("turbolinks:load", function() {
  var tbl_evaluation = $("#evaluation-tbl");
  if(tbl_evaluation.length > 0) {
    set_datatable(tbl_evaluation, [0, 2, 3, 4]);
  }
});
