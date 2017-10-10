import lozad from 'lozad'

$ ->
	observer = lozad '.lozad',
		rootMargin: '400px 0px',
		threshold: 0

	videoObserver = lozad '.video-lozad',
		rootMargin: '300px 0px',
		threshold: 0,
		load: (el) ->
			$this = $(el)
			{ poster, video, type } = $this.data()
			$this.attr 'poster', poster
			tempSource = document.createElement('source')
			tempSource.src = video
			tempSource.type = type
			el.appendChild tempSource

			el.addEventListener 'canplaythrough', ->
				$this.addClass 'is-loaded'
				# force play
				el.play() if $this.closest('.product-cover.hover, .product-cover.active').length

	initLazyLoad = ->
		observer.observe()
		videoWasInit = false
		if !isMobile()
			videoWasInit = true
			videoObserver.observe()

		controller.resizeSceneActions.push ->
			if !isMobile() and !videoWasInit
				videoWasInit = true
				videoObserver.observe()

	initLazyLoad()

	$(document).on 'init-lazy-load', initLazyLoad
