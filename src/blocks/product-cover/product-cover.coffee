$ ->
	$block = $(".product-cover")
	return unless $block.length
	$catalog = $(".catalog")

	$block.on "click", (e) ->
		$target = $(@).attr("data-target")
		$catalog.find($target).slideToggle(200)
