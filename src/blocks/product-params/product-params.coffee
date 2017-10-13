$ ->
	productParamsJS = ->
		$block = $('.product-params')
		return unless $block.length

		handleTotalChange = ($this) ->
			priceList = $this.data 'price-list'
			volume = $this.find('.product-params__volume .product-params__item.active').data 'volume'
			pack = $this.find('.product-params__packs .product-params__item.active').data 'pack'
			$this.find('.product-params__cart-total-value').text('$ ' + priceList["#{volume}-#{pack}"])

		$block.each ->
			handleTotalChange $(@)

		#
		# Handle ingredients click
		#
		$ingredientsBtn = $block.find('.product-params__ingredients-header')
		$ingredientsBtn.on 'click', ->
			$this = $(@)
			$ingredientsInner = $this.parent().find('.product-params__ingredients-inner')
			$paramsIngredient = $this.parent().find('.product-params__ingredients')
			$params = $this.parents('.product-params')
			isClosed = $this.hasClass 'closed'
			ingredientsOrigin = $ingredientsInner.outerHeight()
			ingredientsHeight = if isClosed then ingredientsOrigin else 0
			paramsHeightDiff = if isClosed then ingredientsOrigin else - ingredientsOrigin
			tl = new TimelineMax()

			tl
				.to $params, 0.2, { height: $params.outerHeight() + paramsHeightDiff, ease: Power0.easeNone }, 0

			if isClosed
				tl.fromTo $paramsIngredient, 0.2, { height: 0 }, { height: ingredientsHeight, autoAlpha: 1, ease: Power0.easeNone }, 0
			else
				tl.to $paramsIngredient, 0.2, { height: 0, autoAlpha: 0, ease: Power0.easeNone }, 0

			$this.toggleClass 'closed'

		#
		# Handle Cart params changes
		#

		$cartButton = $block.find('.product-params__cart-button')
		$cartButton.each ->
			$this = $(@)
			$parentCart = $this.parents '.product-params__cart'
			$this.click ->
				if !$parentCart.hasClass 'added'
					$parentCart.addClass 'added'
					$this.text 'Added to Cart'

					#
					# dispatch cart update
					#

					$parent = $this.parents('.product-params')
					productSlug = $parent.data 'product'
					productTitle = $parent.data 'title'
					productImg = $parent.data 'image'
					priceList = $parent.data 'price-list'
					volume = $parent.find('.product-params__volume .product-params__item.active').data 'volume'
					pack = $parent.find('.product-params__packs .product-params__item.active').data 'pack'

					order =
						"#{productSlug}":
							title: productTitle
							image: productImg
							packs:
								"#{volume}-#{pack}":
									amount: 1
									pricePerOne: priceList["#{volume}-#{pack}"]

					$(document).trigger 'addToCart', [ order ]
					setTimeout ->
						$parentCart.removeClass 'added'
						$this.text 'Add to Cart'
					, 2000

		$packSize = $block.find('.product-params__packs .product-params__item')
		$packSize.on 'click touchstart', ->
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

			# update Total
			handleTotalChange $this.parents('.product-params')

		$volumes = $block.find('.product-params__volume .product-params__item')
		$volumes.on 'click touchstart', ->
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
			$slider.css 'margin-left', if position then "-" + (position * 100) + "%" else 0
			$slider.find('.product-cover__slider-item')
				.each (index) ->
					$(this).removeClass 'active'
					if index == position
						$(this).addClass 'active'

			# update Total
			handleTotalChange $this.parents('.product-params')

	productParamsJS()

	$(document).on 'product-params', productParamsJS
