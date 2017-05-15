$(document).on("turbolinks:load", function() {
  var total_point = 0;

  $(".evaluation-detail-point").change(function() {
    $(".evaluation-detail-point").each(function() {
      if($(this).val() !== undefined) {
        total_point += parseInt($(this).val());
      }
    });

    document.getElementById("evaluation_total_point").value = total_point;
    total_point = 0;
  });
});
