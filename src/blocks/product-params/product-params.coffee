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

	$packSize = $block.find('.product-params__packs-item')
	$packSize.each ->
		$this = $(@)
		$this.click ->
			activeDots = $this.data 'pack'
			$packSize.each -> $(this).removeClass 'active'
			$this.addClass 'active'
			$dots = $this.parent().parent().find('.product-params__packs-dot')
			$dots.each (index) ->
				if index < $dots.length - activeDots
					$(this).addClass 'disabled'
				else
					$(this).removeClass 'disabled'

	$volumes = $block.find('.product-params__volume-item')
	$volumes.each ->
		$this = $(@)
		$this.click ->
			$volumes.each ->
				$(this).removeClass 'active'
			$this.addClass 'active'
