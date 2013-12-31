# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

	lyric_field = $("form.edit_song #song_lyrics")

	get_rhymes = (lyrics) ->
		url = $("form.edit_song").attr('action')
		$.ajax "#{ url }.js",
			type: 'POST'
			data:
				_method: "patch"
				song:
					lyrics: lyrics

	lyric_field.on 'paste', -> get_rhymes $(@).val()

	lyric_field.bind 'keyup', (e) ->
		get_rhymes $(@).val() if e.which == 13
