# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  count = 0
  $(".panel").each (index) ->
    if $("#response_tag").val() is ""
      $(this).show()
      count++
    else
      unless $(this).data("response") is $("#response_tag").val()
        $(this).hide()
      else
        $(this).show()
        count++
      
  if count > 0
    $("#no_guest_found").hide()

  $("#guest_count").html(count)
      
  $("#response_tag").change ->
    $("#no_guest_found").hide()
    count = 0
    $(".panel").each (index) ->
      if $("#response_tag").val() is ""
        count++
        $(this).show()
      else
        unless $(this).data("response") is $("#response_tag").val()
          $(this).hide()
        else
          count++
          $(this).show()
    if count == 0
      $("#no_guest_found").show()
  
    $("#guest_count").html(count)
  

  $(".edit_invite").on("ajax:success", (e, data, status, xhr) ->
    $("#alert_success").text(data.response).fadeIn(300).delay(2000).fadeOut(300 )
  ).bind "ajax:error", (e, xhr, status, error) ->
    $("#alert_danger").text("Sorry, there was an error. Please try again.").fadeIn(300).delay(2000).fadeOut(300 )

  $("a[data-remote]").on("ajax:success", (e, data, status, xhr) ->
    $("#row"+data.id).fadeOut(300)
    $("#alert_success").text(data.response).fadeIn(300).delay(2000).fadeOut(300 )
    
  ).bind "ajax:error", (e, xhr, status, error) ->
    $("#alert_danger").text("Sorry, there was an error. Please try again.").fadeIn(300).delay(2000).fadeOut(300 )
