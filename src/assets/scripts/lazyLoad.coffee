import { Scene } from 'scrollmagic'

$ ->

	loadImage = ($this) ->
		{ src } = $this.data()
		img = new Image()
		img.onload = ->
			$this.css 'background-image', "url(#{src})"
		img.src = src

	initLazyLoad = ->
		$imageLoad = $('.lazy-image')
		return unless $imageLoad.length

		cntrl = controller.get()

		$imageLoad.each ->
			$this = $(@)
			loadScene = new Scene({
				triggerElement: @,
				triggerHook: 1,
				offset: -400,
				})
				.addTo cntrl
				.on 'enter', ->
					loadScene.destroy()
					loadImage $this

	initLazyLoad()

	$(document).on 'init-lazy-load', initLazyLoad
