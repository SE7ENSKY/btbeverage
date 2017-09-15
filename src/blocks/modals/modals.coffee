$ ->
	$block = $(".modals")
	return unless $block.length
	$modalLink = $block.find("[data-toggle='modal']")

	$modalLink.on "click", (e) ->
		setTimeout ->
			$("body").addClass("modal-open")
		, 400