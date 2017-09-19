import jQueryBridget from 'jquery-bridget'
import Flickity from 'flickity'

$ ->
	jQueryBridget('flickity', Flickity, $ )
	galleryJS = ->
		$block = $(".gallery")
		return unless $block.length
		$item = $(".gallery__item")

		if $item.length > 3
			$block.flickity
				wrapAround: true
				pageDots: false
				initialIndex: 1

	galleryJS()

	$(document).on 'gallery', galleryJS
