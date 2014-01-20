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
  
	$("#guest_is_family").change(function() {
		if(this.checked) {
			$('#household_name').fadeIn('slow');
		} else {
			$('#household_name').fadeOut('slow');
		}
	});
	
	if($('#guest_is_family').is(':checked')) {
		$('#household_name').show();
	} else {
		$('#household_name').hide();
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
    
});
