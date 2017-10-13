window.setHash = (hash) ->
	history.pushState(null, null, "#{window.location.pathname}##{hash}")

window.removeHash = ->
	history.pushState(null, null, window.location.pathname)
