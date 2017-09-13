$ ->
	$block = $('.product-params')
	return unless $block.length

	$cartButton = $block.find('.product-params__cart-button')

	$cartButton.each ->
		$this = $(@)
		$this.click ->
			$this
				.parent '.product-params__cart'
				.toggleClass 'added'
