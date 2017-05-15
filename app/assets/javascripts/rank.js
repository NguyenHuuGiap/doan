$(document).on("turbolinks:load", function() {
  var tbl_rank = $("#rank-tbl");
  if(tbl_rank.length > 0) {
    set_datatable(tbl_rank, [0, 2, 3, 4, 5]);
  }
});
