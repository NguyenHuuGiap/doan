$(document).on("turbolinks:load", function() {
  var tbl_training_managements = $("#training-managements-tbl");
  var default_dom = "<'row'<'col-sm-10'f><'col-sm-2'l>>"
  + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>";

  if(tbl_training_managements.length > 0) {
    tbl_training_managements.dataTable({
      retrieve: true,
      "dom": default_dom,
      bJQueryUI: true,
      bProcessing: true,
      bServerSide: true,
      "scrollX": true,
      aLengthMenu: [
        [5, 10, 20, 50, 100, -1],
        [5, 10, 20, 50, 100, "All"]
      ],
      order: [1],
      "columnDefs": [{"orderable": false, "targets": []}],
      "pageLength": 50,
      sAjaxSource: tbl_training_managements.data("source"),
      language: {
        search: "_INPUT_",
        searchPlaceholder: I18n.t("datatables.search_name"),
        sLengthMenu: I18n.t("datatables.show_menu")
      }
    });
  }
});
