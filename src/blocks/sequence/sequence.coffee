$ ->
	widthRatio = 0.60625 # 960 x 582
	menuHeight = 80
	isSequenceLoaded = false

	sequenceJS = ->
		$block = $('.sequence')
		if !$block.length or isMobile() or isPortrait() or isSequenceLoaded
			$(document).trigger 'sequence-loaded'
			$(document).trigger 'connect-pixi' if isSequenceLoaded
			return

		$(document).trigger 'connect-pixi'

		pixi.frames = []

		onPixiSetup = (loader, resources) ->
			$(document).trigger 'sequence-loaded'

			pixi.frames = Object.keys(resources).map (key) ->
				resources[key].texture

			pixi.sprite = new PIXI.Sprite pixi.frames[0]
			realHeight = window.innerHeight - menuHeight
			realWidth = realHeight * widthRatio
			pixi.sprite.height = realHeight
			pixi.sprite.width = realWidth
			pixi.sprite.anchor.set(0.5, 0.5)

			pixi.sprite.position.x = pixi.app.renderer.width / 2
			pixi.sprite.position.y = pixi.app.renderer.height / 2

			pixi.app.stage.addChild pixi.sprite

			isSequenceLoaded = true

		loader = new PIXI.loaders.Loader()
		{ amount, dir } = $block.data()

		fillArray = (amount, dir) ->
			arr = Array.apply null, Array(amount)
			fixNumberString = (value) ->
				count = 3 - value.toString().length
				res = value
				while count-- > 0
					res = "0" + res
				res

			arr.map (x, i) -> "#{dir}/#{fixNumberString(i + 1)}.png"

		loader
			.add fillArray(amount, dir)
			.load onPixiSetup

	$(document).on 'sequence-init', sequenceJS
