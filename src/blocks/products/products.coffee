$ ->

	initProductPageJS = ->
		$block = $('.page_products')
		return unless $block.length

		hash = window.location.hash
		$product = $(hash)
		return unless $product.length

		setTimeout ->
			$(document).trigger 'catalog-handle-hash', [ $product ]
		, 500

	initProductPageJS()

	$(document).on 'init-product-page', initProductPageJS
