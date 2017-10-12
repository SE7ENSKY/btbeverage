window.setHash = (hash) ->
		history.pushState(null, null, "#{window.location.pathname}##{hash}")
