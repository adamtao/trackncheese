# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$("div#finish_on_picker").datepicker(
		altField: "#project_finish_on",
		altFormat: "yy-mm-dd",
		defaultDate: $("div#finish_on_picker").data('default')
	)
