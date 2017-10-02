$ ->

	catalogStructureJS = ->
		$block = $('.catalog')
		return unless $block.length

		$desktop = $block.find('.catalog__desktop')
		$mobile = $block.find('.catalog__mobile')

		isInDOM = (el) -> !jQuery.contains document, el[0]

		handleStructure = ->
			if isMobile()
				$desktop = $desktop.remove() if $block.find('.catalog__desktop').length
				$mobile.appendTo('.catalog') if !$block.find('.catalog__mobile').length
			else
				$mobile = $mobile.remove() if $block.find('.catalog__mobile').length
				$desktop.appendTo('.catalog') if $block.find('.catalog__desktop').length
			$(document).trigger 'product-cover'
			$(document).trigger 'product-params'

		handleStructure()

		controller.resizeSceneActions.push ->
			handleStructure()

	catalogStructureJS()

	$(document).on 'catalog-init', catalogStructureJS
