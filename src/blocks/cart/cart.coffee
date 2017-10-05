$ ->

	initCartControls = ->
		$block = $('.cart')
		return unless $block.length

		$cartControls = $block.find '.cart__controls-item'
		$totalSum = $block.find '.cart__total-value'

		$cartControls.on 'click', ->
			$this = $(@)
			$productRow = $this.parents('.cart__product-row')
			$product = $this.parents('.cart__product')
			{ sizekey, price, amount } = $productRow.data()
			{ slug } = $product.data()

			actionValue = if $this.hasClass('cart__controls-item_plus') then 1 else -1
			newAmount = +amount + actionValue
			if newAmount < 0
				product =
					"#{slug}": "#{sizekey}"

				$(document).trigger 'delete-cart-product', [ product ]
				$productRow.remove()
				unless $product.find('.cart__product-row').length
					$product.parent('.cart__list-item').remove()
				unless $('.cart__list-item').length
					$('.cart').addClass 'empty-cart'


			else
				#
				# update params and texts
				#

				[volume, packSize] = sizekey.split '-'
				$productRow.data 'amount', newAmount
				$productRow.find('.cart__product-info').text(newAmount + " x " + volume + ", pack of " + packSize)
				$productRow.find('.cart__product-price').text('$ ' + (+price * newAmount).toFixed(2))

				#
				# handle cookie update
				#

				product =
					"#{slug}":
						"#{sizekey}": newAmount

				$(document).trigger 'handle-cart-change', [ product ]

			#
			# update Total
			#

			total = calculateTotal()
			$totalSum.text('$ '+ total.toFixed(2))

	$(document).on 'init-cart-controls', initCartControls
	$(document).trigger 'update-cart'
