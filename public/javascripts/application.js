jQuery(function($) {
  // jQUery-UI
  $('.datepicker').datepicker({
    selectOtherMonths: true
  });

  // jQuery Time Entry
  $('.time-entry').timeEntry( { show24Hours: true, spinnerImage: '' } );
});
