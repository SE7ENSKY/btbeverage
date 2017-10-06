import Inputmask from 'inputmask'

$ ->
	paymentChooserJS = ->
		$block = $('.payment-chooser')
		return unless $block.length
		$item = $block.find(".payment-chooser__item")
		$toggler = $block.find('.payment-chooser__item-header')
		$wrap = $block.find(".payment-chooser__item-wrap")

		Inputmask({ mask: "9999-9999-9999-9999", "placeholder": "_" }).mask('.card-number')
		Inputmask({ mask: "99/99", "placeholder": "_" }).mask('.card-expire')
		Inputmask({ mask: "999", "placeholder": " " }).mask('.card-cvv')

		$toggler.on 'click', (e) ->
			$parent = $(@).closest(".payment-chooser__item")
			unless $parent.hasClass("active")
				$item.removeClass('active')
				$parent.addClass("active")

	paymentChooserJS()

	$(document).on 'payment-chooser', paymentChooserJS
