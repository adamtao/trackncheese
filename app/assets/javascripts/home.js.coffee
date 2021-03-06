# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$("div#finish_on_picker").datepicker(
		altField: "#project_finish_on",
		altFormat: "yy-mm-dd",
		defaultDate: $("div#finish_on_picker").data('default')
	)

	# hide the text field with the date (don't use a hidden field so we can test the form)
	$("form#new_project div.project_finish_on").hide()

	$("form.edit_project #project_finish_on").datepicker(
		altField: "#project_finish_on",
		altFormat: "yy-mm-dd"
	)
	$("#task_due_on").datepicker(
		altField: "#task_due_on",
		altFormat: "yy-mm-dd"
	)
	
	$('#calendar').fullCalendar
		events: $('#calendar').data('events')
		year: $('#calendar').data('year')
		month: $('#calendar').data('month')
		date: $('#calendar').data('date')
		theme: false
		header: {
			left: 'title',
			center: '',
			right: 'prev,next'
		}

