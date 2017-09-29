$ ->
	widthRatio = 0.625 # 720 x 450

	sequenceJS = ->
		$block = $('.sequence')
		if !$block.length
			$(document).trigger 'sequence-loaded'
			return

		pixi.frames = []

		onPixiSetup = (loader, resources) ->
			$(document).trigger 'sequence-loaded'
			
			for i, item of resources.seq.textures
				pixi.frames.push(item)

			pixi.sprite = new PIXI.Sprite pixi.frames[0]
			realHeight = window.innerHeight
			realWidth = realHeight * widthRatio
			pixi.sprite.height = realHeight
			pixi.sprite.width = realWidth
			pixi.sprite.anchor.set(0.5, 0.5)

			pixi.sprite.position.x = pixi.app.renderer.width / 2
			pixi.sprite.position.y = pixi.app.renderer.height / 2

			pixi.app.stage.addChild pixi.sprite

		loader = new PIXI.loaders.Loader()
		loader
			.add 'seq', '/assets/i/seq/btseq.json'
			.load onPixiSetup

	$(document).on 'sequence-init', sequenceJS
