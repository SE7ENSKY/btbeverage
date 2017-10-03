import Cookie, { getJSON } from './cookie'

$ ->

	expires = 1440

	window.calculateTotal = ->
		cart = getJSON Cookie.get('bt-cart')
		return 0 if !cart or !Object.keys(cart).length

		products = convertToArray cart
		total = products.reduce (prev, curr) ->
			packsList = convertToArray curr.packs
			return prev + packsList.reduce (prevPack, currPack) ->
				prevPack + currPack.amount * currPack.pricePerOne
			, 0
		, 0

		return total

	updateCartBadge = ->
		cart = getJSON Cookie.get('bt-cart')
		$cartInMenu = $('.header__menu-link[href="#cart-modal"]')
		$cartBadge = $cartInMenu.find '.header__menu-badge'

		return unless $cartBadge.length
		return $cartBadge.text "0" if !cart or !Object.keys(cart).length

		productsInCart = 0
		for productSlug in Object.keys(cart)
			productPacks = cart[productSlug].packs
			productsInCart = Object.keys(productPacks)
				.reduce (prev, curr) ->
					prev + productPacks[curr].amount
				, productsInCart

		$cartBadge.text productsInCart

	addToCart = (ev, order) ->
		cart = getJSON Cookie.get('bt-cart')
		productSlug = Object.keys(order)[0]
		sizeKey = Object.keys(order[productSlug].packs)[0]

		if !cart
			Cookie.set 'bt-cart', JSON.stringify(order), { expires: expires }
		else if cart[productSlug]
			if cart[productSlug]['packs'][sizeKey]
				cart[productSlug]['packs'][sizeKey].amount += 1
			else
				cart[productSlug]['packs'][sizeKey] = order[productSlug]['packs'][sizeKey]
			Cookie.set 'bt-cart', JSON.stringify(cart), { expires: expires }
		else
			cart = { ...cart, ...order }
			Cookie.set 'bt-cart', JSON.stringify(cart), { expires: expires }

		updateCartBadge()

	handleCartChange = (ev, product) ->
		productSlug = Object.keys(product)[0]
		sizeKey = Object.keys(product[productSlug])[0]
		cart = getJSON Cookie.get('bt-cart')

		if !cart
			Cookie.set 'bt-cart', JSON.stringify(product), { expires: expires }
		else if cart[productSlug]
			if cart[productSlug]['packs'][sizeKey]
				cart[productSlug]['packs'][sizeKey].amount = product[productSlug][sizeKey]
				Cookie.set 'bt-cart', JSON.stringify(cart), { expires: expires }

		updateCartBadge()

	updateCartModal = ->
		cart = getJSON Cookie.get('bt-cart')
		$modal = $('#cart-modal')
		$cartList = $modal.find '.cart__list'
		$cartList.empty()

		if !cart or !Object.keys(cart).length
			$('.cart').addClass 'empty-cart'
			return
		else
			$('.cart').removeClass 'empty-cart'

		Object.keys(cart).reduce (prev, curr) ->
			product = cart[curr]
			$listItem = $('<div class="cart__list-item"></div>')
			$productEl = $("<div class='cart__product' data-slug='#{curr}'></div>")
			$productImage = $('<div class="cart__product-image"></div>')
			$productImage.css 'background-image', "url(#{product.image})"
			$productTitle = $("<div class='cart__product-title'>#{product.title}</div>")

			#product-content
			$productContent = $("<div class='cart__product-content'></div>")
			subItems = convertToArray product.packs
			for item in subItems
				$productRow = $("<div class='cart__product-row'
					data-sizekey='#{item.key}'
					data-price='#{item.pricePerOne}'
					data-amount='#{item.amount}'
					></div>")
				[volume, packSize] = item.key.split "-"

				# title
				$productRow.append "<div class='cart__product-info'>#{item.amount + " x " + volume + ", pack of " + packSize}</div>"

				#price
				$productRow.append "<div class='cart__product-price'>#{(item.pricePerOne * item.amount).toFixed(2)}</div>"

				#controls
				$productRow.append "<div class='cart__controls'>
					<div class='cart__controls-item cart__controls-item_plus'></div>
					<div class='cart__controls-item cart__controls-item_minus'></div>
					</div>"

				#add to main
				$productContent.append $productRow

			# compile
			$productImage.append($productTitle)
			$productEl.append($productImage)
			$productEl.append($productContent)

			$listItem.append($productEl)
			prev.append($listItem)
		, $cartList

		$(document).trigger 'init-cart-controls'

	$(document).on 'addToCart', addToCart
	$(document).on 'updateCartBadge', updateCartBadge
	$(document).on 'update-cart-modal', updateCartModal
	$(document).on 'handle-cart-change', handleCartChange
