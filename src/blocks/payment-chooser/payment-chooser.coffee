import Inputmask from 'inputmask'
import { TweenMax } from 'gsap'

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
			$parentInner = $parent.find(".payment-chooser__item-inner")
			$prevActive = $block.find(".payment-chooser__item.active")

			unless $parent.hasClass("active")
				$item.removeClass('active')
				$parent.addClass("active")
				if $parentInner.length
					TweenMax.to $parent.find(".payment-chooser__item-wrap"), 0.3, { height: $parentInner.outerHeight() }

				$prevActiveWrap = $prevActive.find(".payment-chooser__item-wrap")
				if $prevActiveWrap.length
					$prevActiveInner = $prevActiveWrap.find(".payment-chooser__item-inner")
					TweenMax.fromTo $prevActiveWrap, 0.3, { height: $prevActiveInner.outerHeight() }, { height: 0 }

	paymentChooserJS()

	$(document).on 'payment-chooser', paymentChooserJS
