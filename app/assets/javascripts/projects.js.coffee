jQuery ($) ->
	$('input.completer').prop("checked", false).each -> new Completer(@) 
	$('input.incompleter').prop("checked", true).each -> new Completer(@)

class Completer

	constructor: (checkbox) ->
		@checkbox = $(checkbox)
		@task_id = @checkbox.data('task') 
		@project_id = @checkbox.data('project')
		@song_id = @checkbox.data('song')
		@due_on = @checkbox.data('due-on')
		@checkbox.click () =>
			@update_counters()
			if @checkbox.hasClass('completer') then @complete() else @uncomplete(@due_on)
			@update_database()
			@update_progress()
		
	update_progress: ->
		$('#completed-tasks-title').html("Completed Tasks (#{@project_completed_count})")
		percent_complete = Math.floor ((@project_completed_count / (@project_incomplete_count + @project_completed_count) ) * 100)
		$("span#meter-#{ @project_id }").css('width', "#{ percent_complete }%")
		$("#percent-complete-#{ @project_id }").html(" #{ percent_complete }% complete")

	update_database: ->
		$.ajax "/projects/#{@project_id}/tasks/#{@task_id}/toggle.js"

	update_counters: () ->
		@project_task_counter = $("#task-counter-#{ @project_id }")
		@project_completed_count = @project_task_counter.data('completedcount')
		@project_incomplete_count = @project_task_counter.data('incompletecount')
		if @checkbox.hasClass('completer')
			@project_completed_count += 1
			@project_incomplete_count -= 1
		else
			@project_completed_count -= 1
			@project_incomplete_count += 1
		@project_task_counter.data('completedcount', @project_completed_count)
		@project_task_counter.data('incompletecount', @project_incomplete_count)
		@update_progress

	complete: ->
		@checkbox.removeClass('completer').addClass('incompleter')
		$("#task_row_#{@task_id}").fadeOut 'fast', ->
			$(@).find('input').prop("checked", true)
			$(@).find('i').html('completed: just now')
			$(@).prependTo('ul#completed-tasks').fadeIn('fast')
	
	uncomplete: (d) ->
		@checkbox.removeClass('incompleter').addClass('completer')
		$("#task_row_#{@task_id}").fadeOut 'fast', ->
			$(@).find('input').prop("checked", false)
			$(@).find('i').html("due: #{ d }")
			$(@).prependTo('ul#task-list').fadeIn('fast')			
	
		



