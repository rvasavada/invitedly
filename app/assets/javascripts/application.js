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
//= require jquery.datetimepicker
//= require jquery.tablesorter.min
//= require jquery.tablesorter.widgets.min
//= require cocoon
//= require_tree .

$("document").ready(function(){
    
	//calendar feature on new events
	$(document).ready(function(){	
		$('.datepicker').datetimepicker({
    	timepicker:false,
			format: "M d, Y"
			});
	});
  
  $('#spinner').datetimepicker({
    datepicker:false,
    step:30,
    format:'g:i A',
    formatTime:'g:i A',
    timepicker: true,
    lang: 'en'
  });
  
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
          $(this).hide(); 
      });
  }, 4000);
  
  $('a[rel~="tooltip"]').tooltip();
  $('a[rel~="popover"]').on("mouseenter", function () {
        var _this = this;
        $(this).popover("show");
        $(".popover").on("mouseleave", function () {
            $(_this).popover('hide');
        });
    }).on("mouseleave", function () {
        var _this = this;
        setTimeout(function () {
            if (!$(".popover:hover").length) {
                $(_this).popover("hide")
            }
        }, 100);
    }).click(function(e) {
        e.preventDefault();
     });
  
});
