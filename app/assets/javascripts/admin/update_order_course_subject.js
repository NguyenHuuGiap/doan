$(document).on("turbolinks:load", function() {
  jQuery(function() {
    var cells, desired_width, table_width;
    if ($('#sortable').length > 0) {
      table_width = $('#sortable').width();
      cells = $('.table').find('tr')[0].cells.length;
      desired_width = table_width / cells + 'px';
      $('.table td').css('width', desired_width);
      return $('#sortable').sortable({
        axis: 'y',
        items: '.item',
        cursor: 'move',
        sort: function(e, ui) {
          return ui.item.addClass('active-item-shadow');
        },
        stop: function(e, ui) {
          ui.item.removeClass('active-item-shadow');
          return ui.item.children('td').effect('highlight', {}, 1000);
        },
        update: function(e, ui) {
          var item_id, position, url;
          item_id = ui.item.data('item-id');
          url = ui.item.data('url');
          position = ui.item.index();
          return $.ajax({
            type: 'PATCH',
            url: url,
            dataType: 'json',
            data: {
              course_subject: {
                row_order_position: position
              }
            }
          });
        }
      });
    }
  });
});
