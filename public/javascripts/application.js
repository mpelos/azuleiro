jQuery(function($) {
  // jQUery-UI
  $('.datepicker').datepicker({
    selectOtherMonths: true,
    onSelect:          function(dateText, inst) {
                         var self = $('#' + inst.id);
                         var formattedDateText = dateText.slice(6, 10) + dateText.slice(3, 5) + dateText.slice(0, 2);
                         var endDepartDate = $('#travel_end_depart_date').attr('value');
                         var formattedEndDepartDate = endDepartDate.slice(6, 10) + endDepartDate.slice(3, 5) + endDepartDate.slice(0, 2);
                         var startReturnDate = $('#travel_start_return_date').attr('value');
                         var formattedStartReturnDate = startReturnDate.slice(6, 10) + startReturnDate.slice(3, 5) + startReturnDate.slice(0, 2);
                         var endReturnDate = $('#travel_end_return_date').attr('value');
                         var formattedEndReturnDate = endReturnDate.slice(6, 10) + endReturnDate.slice(3, 5) + endReturnDate.slice(0, 2);
                         if($(self).data('order') == 1 && formattedDateText > formattedEndDepartDate) {
                           $('#travel_end_depart_date').attr('value', dateText);
                         };

                         if($(self).data('order') <= 2 && formattedDateText > formattedStartReturnDate) {
                           $('#travel_start_return_date').attr('value', dateText);
                         };

                         if($(self).data('order') <= 3 && formattedDateText > formattedEndReturnDate) {
                           $('#travel_end_return_date').attr('value', dateText);
                         };
                       }
  });

  // jQuery Time Entry
  $('.time-entry').timeEntry( { show24Hours: true, spinnerImage: '' } );

  // Twitter's Bootstrap
  $('.alert-message').alert();
});
