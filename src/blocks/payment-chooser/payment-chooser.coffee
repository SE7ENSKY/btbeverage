$ ->
	$block = $('.payment-chooser')
	return unless $block.length
	$item = $block.find(".payment-chooser__item")
	$toggler = $block.find('.payment-chooser__item-header')
	$wrap = $block.find(".payment-chooser__item-wrap")

	$toggler.on 'click', (e) ->
		$parent = $(@).closest(".payment-chooser__item")
		unless $parent.hasClass("active")
			$item.removeClass('active')
			$parent.addClass("active")