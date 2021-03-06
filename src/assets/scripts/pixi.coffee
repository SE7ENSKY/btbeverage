$ ->
	widthRatio = 0.625 # 720 x 450

	window.pixi =
		app: new PIXI.Application
			width: window.innerHeight * widthRatio 
			height: window.innerHeight
			transparent: true
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

	document.getElementsByClassName('sequence')[0].appendChild(pixi.app.view)

	window.addEventListener 'resize', ->
		h = window.innerHeight
		w = h * widthRatio
		pixi.resize w, h
		if pixi.sprite
			pixi.sprite.position.x = pixi.app.renderer.width / 2
			pixi.sprite.position.y = pixi.app.renderer.height / 2
		pixi.rerender()
