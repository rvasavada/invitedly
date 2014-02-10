// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.10.3.custom.min
//= require jquery.timepicker.min
//= require cocoon
//= require bootstrap.min.js
//= require_tree .

$("document").ready(function(){
    
	//calendar feature on new events
	$(document).ready(function(){	
		$('.datepicker').datepicker({
			dateFormat: "M d, yy"
			});
	});
  
	$('#spinner').timepicker({ 'scrollDefaultNow': true });

	$('.event-info').popover({placement:'top'});
	
	$("#countrySelect").change(function() {
		if($("#countrySelect").val() == "United States") {
			$(".international").hide();
			$(".domestic").show();
		} else {
			$(".international").show();
			$(".domestic").hide();
		}
	});
	
	if($("#countrySelect").val() == "United States") {
		$(".international").hide();
		$(".domestic").show();
	} else {
		$(".international").show();
		$(".domestic").hide();
	}
  
  
	$("#guest_invitations_send_email").change(function() {
		if(this.checked) {
			$('#invitation_send_date').fadeIn('slow');
		} else {
			$('#invitation_send_date').fadeOut('slow');
		}
	});
	
	if($('#guest_invitations_send_email').is(':checked')) {
		$('#invitation_send_date').show();
	} else {
		$('#invitation_send_date').hide();
	}
  
  window.setTimeout(function() {
      $(".alert").fadeTo(500, 0).slideUp(500, function(){
          $(this).remove(); 
      });
  }, 4000);
  
  $("table thead th:last").data("sorter", false).data("filter", false);
  
  // call the tablesorter plugin and apply the uitheme widget
  $("table").tablesorter({
    // this will apply the bootstrap theme if "uitheme" widget is included
    // the widgetOptions.uitheme is no longer required to be set
    theme : "bootstrap",

    headers: { numcols :{sorter:false} },

    // widget code contained in the jquery.tablesorter.widgets.js file
    // use the zebra stripe widget if you plan on hiding any rows (filter widget)
    widgets : [ "uitheme", "filter", "zebra" ],

    widgetOptions : {
      zebra : ["even", "odd"],
      filter_reset : ".reset",
      filter_functions : {
              // Add select menu to this column
              // set the column value to true, and/or add "filter-select" class name to header
              0 : true,
              2 : true,
              3 : true,
              4 : true,
              5 : true,
              6 : true,
              7 : true,
              8 : true,
              9 : true,
              10 : true,
              11 : true,
              12 : true,
              13 : true,
              14 : true,
              15 : true,
            }
    }
  });
  
  $(".tablesorter-filter").addClass("form-control input-sm");
  $(".tablesorter-filter.disabled").hide();
  
});
