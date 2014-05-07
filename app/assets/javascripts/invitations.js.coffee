# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.extend $.tablesorter.themes.bootstrap,
  
  # these classes are added to the table. To see other table classes available,
  # look here: http://twitter.github.com/bootstrap/base-css.html#tables
  table: "table"
  caption: "caption"
  header: "bootstrap-header" # give the header a gradient background
  footerRow: ""
  footerCells: ""
  icons: "" # add "icon-white" to make them white; this icon class is added to the <i> in the header
  sortNone: "bootstrap-icon-unsorted"
  sortAsc: "icon-chevron-up glyphicon glyphicon-chevron-up" # includes classes for Bootstrap v2 & v3
  sortDesc: "icon-chevron-down glyphicon glyphicon-chevron-down" # includes classes for Bootstrap v2 & v3
  active: "" # applied when column is sorted
  hover: "" # use custom css here - bootstrap class may not override it
  filterRow: "" # filter row class
  even: "" # odd row zebra striping
  odd: "" # even row zebra striping

$("table#invitation_guest thead th:last").data("sorter", false).data "filter", false
$("table#invitation_guest").tablesorter
  theme: "bootstrap"
  cssChildRow: "edit_row"
  headerTemplate: "{content} {icon}"
  widgets: [
    "uitheme"
    "stickyHeaders"
  ]
  widgetOptions:
    filter_reset: ".reset"
    filter_functions:
      1: true
      2: true
      3: true
      4: true
      5: true
      6: true
      7: true
      8: true
      9: true
      10: true
      11: true
      12: true
      13: true
      14: true
      15: true
    
    # extra class name added to the sticky header row
    stickyHeaders: "stickyHeader"
    
    # number or jquery selector targeting the position:fixed element
    stickyHeaders_offset: 0
    
    # added to table ID, if it exists
    stickyHeaders_cloneId: "-sticky"
    
    # trigger "resize" event on headers
    stickyHeaders_addResizeEvent: true
    
    # if false and a caption exist, it won't be included in the sticky header
    stickyHeaders_includeCaption: true
    
    # The zIndex of the stickyHeaders, allows the user to adjust this to their needs
    stickyHeaders_zIndex: 2
    
    # jQuery selector or object to attach sticky header to
    stickyHeaders_attachTo: null

#$(".tablesorter-filter").addClass "form-control input-sm"
#$(".tablesorter-filter.disabled").hide()