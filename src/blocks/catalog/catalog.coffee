$ ->

	catalogStructureJS = ->
		$block = $('.catalog')
		return unless $block.length
		firstInitIsMobile = isMobile()
		desktopEventConnected = !firstInitIsMobile
		mobileEventConnected = firstInitIsMobile

		$desktop = $block.find('.catalog__desktop')
		$mobile = $block.find('.catalog__mobile')

		isInDOM = (el) -> !jQuery.contains document, el[0]

		handleStructure = ->
			if isMobile()
				$desktop = $desktop.detach() if $block.find('.catalog__desktop').length
				$mobile.appendTo('.catalog') if !$block.find('.catalog__mobile').length
				if !mobileEventConnected
					$(document).trigger 'product-cover'
					$(document).trigger 'product-params'
					mobileEventConnected = true
			else
				$mobile = $mobile.detach() if $block.find('.catalog__mobile').length
				$desktop.appendTo('.catalog') if !$block.find('.catalog__desktop').length
				if !desktopEventConnected
					$(document).trigger 'product-cover'
					$(document).trigger 'product-params'
					desktopEventConnected = true

		handleStructure()

		controller.resizeSceneActions.push ->
			handleStructure()

	catalogStructureJS()

	$(document).on 'catalog-init', catalogStructureJS
