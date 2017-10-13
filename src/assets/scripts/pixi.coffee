$ ->
	widthRatio = 0.60625 # 960 x 582
	menuHeight = 80

	window.pixi =
		app: new PIXI.Application
			width: window.innerHeight * widthRatio
			height: window.innerHeight - menuHeight
			transparent: true
			forceCanvas: true
		frames: []
		sprite: null
		rerender: ->
			this.app.renderer.render this.app.stage
		resize: (w, h)->
			if pixi.sprite
				realHeight = h #Math.max h, 650
				realWidth = realHeight * widthRatio
				pixi.sprite.height = realHeight
				pixi.sprite.width = realWidth
			this.app.renderer.resize w, h

	window.addEventListener 'resize', ->
		h = window.innerHeight - menuHeight
		w = h * widthRatio
		pixi.resize w, h
		if pixi.sprite
			pixi.sprite.position.x = pixi.app.renderer.width / 2
			pixi.sprite.position.y = pixi.app.renderer.height / 2
		pixi.rerender()

	connectPixiToDom = ->
		$sequenceBlock = $('.sequence')
		return unless $sequenceBlock.length
		$sequenceBlock.get(0).appendChild(pixi.app.view)

	$(document).on 'connect-pixi', connectPixiToDom
