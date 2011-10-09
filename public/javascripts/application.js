jQuery(function($) {
  // jQUery-UI
  $('.datepicker').datepicker({
    selectOtherMonths: true,
    onSelect:          function(dateText, inst) {
                         var self = $('#' + inst.id);
                         if($(self).data('order') == 1) {
                           $('#travel_end_depart_date').attr('value', dateText);
                         };

                         if($(self).data('order') <= 2) {
                           $('#travel_start_return_date').attr('value', dateText);
                         };

                         if($(self).data('order') <= 3) {
                           $('#travel_end_return_date').attr('value', dateText);
                         };
                       }
  });

  // jQuery Time Entry
  $('.time-entry').timeEntry( { show24Hours: true, spinnerImage: '' } );
});
