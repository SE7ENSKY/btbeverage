import Cookie, { getJSON } from './cookie'

$ ->
	updateCart = (ev, order) ->
		cart = getJSON Cookie.get('cart')
		orderSlug = Object.keys(order)[0]
		if !cart
			Cookie.set 'cart', JSON.stringify(order), { expires: 1440 }
		else if cart[orderSlug]
			cart[orderSlug][order[orderSlug]] = (cart[orderSlug][order[orderSlug]] || 0) + 1
			Cookie.set 'cart', JSON.stringify(cart), { expires: 1440 }
		else
			cart = { ...cart, ...order }
			Cookie.set 'cart', JSON.stringify(cart), { expires: 1440 }

	$(document).on 'updateCart', updateCart
