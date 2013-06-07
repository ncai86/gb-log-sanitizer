# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
console.log 'test' 


$("#upload-form").bind("ajax:error", ->
	$("#loader").hide()
	alert "Error!"
 ).bind("ajax:beforeSend", (e) ->
	$("#loader").show()
).bind("ajax:success", ->
	$("#loader").hide()
) 
	

