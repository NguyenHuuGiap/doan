$(document).on("turbolinks:load", function() {
  $("#select-permission-all").click(function() {
    if(this.checked) {
      $("input[type='checkbox']").each(function() {
        this.checked = true;
      });
    } else {
      $("input[type='checkbox']").each(function() {
        this.checked = false;
      });
    };
  });
});
