$ ->
	productParamsJS = ->
		$block = $('.product-params')
		return unless $block.length

		$cartButton = $block.find('.product-params__cart-button')
		$cartButton.each ->
			$this = $(@)
			$this.click ->
				$this
					.parents '.product-params__cart'
					.addClass 'added'
				$this.text 'Added to Cart'

		$packSize = $block.find('.product-params__packs .product-params__item')
		$packSize.click ->
			$this = $(@)
			activeDots = $this.data 'pack'
			$innerPackSize = $this.parent().find('.product-params__item')
			$innerPackSize.each -> $(this).removeClass 'active'
			$this.addClass 'active'
			$dots = $this.parent().parent().find('.product-params__packs-dot')
			$dots.each (index) ->
				if index < $dots.length - activeDots
					$(this).addClass 'disabled'
				else
					$(this).removeClass 'disabled'

		$volumes = $block.find('.product-params__volume .product-params__item')
		$volumes.click ->
			$this = $(@)
			position = 0

			$innerVolumes = $this.parent().find('.product-params__item')

			$innerVolumes.each (index) ->
				$(this).removeClass 'active'
				if $this.get(0) == $(this).get(0)
					position = index

			$this.addClass 'active'
			$thisProductCover = $(".product-cover.active")

			$slider = $thisProductCover.find('.product-cover__slider-inner')
			$slider.css 'transform', "translateX(#{if position then "-" + (position * if isMobile() then 23 else 50) + "%" else 0})"
			$slider.find('.product-cover__slider-item')
				.each (index) ->
					$(this).removeClass 'active'
					if index == position
						$(this).addClass 'active'

	productParamsJS()

	$(document).on 'product-params', productParamsJS
