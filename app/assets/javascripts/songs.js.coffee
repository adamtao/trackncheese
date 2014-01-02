# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

	lyric_field = $("form.edit_song #song_lyrics")

	get_rhymes = (lyrics) ->
		animateClass = "icon-refresh-animate"
		url = $("form.edit_song").attr('action')
		refresh_icon = $('img#refresh_icon')

		$.ajax("#{ url }.js",
			type: 'POST'
			beforeSend: -> refresh_icon.addClass( animateClass )
			data:
				_method: "patch"
				song:
					lyrics: lyrics
		).done -> refresh_icon.removeClass( animateClass )

	lyric_field.on 'paste', -> get_rhymes $(@).val()

	lyric_field.bind 'keyup', (e) ->
		get_rhymes $(@).val() if e.which == 13

	$('a#refresh_rhymes').click (e) ->
		get_rhymes $(lyric_field).val()
		return false
