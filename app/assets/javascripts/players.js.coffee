# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#players').dataTable( {
    "iDisplayLength": 15,
    "order": [[ 5, "desc" ]]
    "bFilter": false,
    "bLengthChange": false,
    "columns": [
      {'bSortable': false, "width": "5%" },
      {},
      {},
      {},
      {},
      {}
    ]
  } );

$(document).ready(ready)
$(document).on('page:load', ready)