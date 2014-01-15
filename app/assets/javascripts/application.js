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
  
	$("#contact_is_family").change(function() {
		if(this.checked) {
			$('#household_name').fadeIn('slow');
		} else {
			$('#household_name').fadeOut('slow');
		}
	});
	
	if($('#contact_is_family').is(':checked')) {
		$('#household_name').show();
	} else {
		$('#household_name').hide();
	}
	
});
