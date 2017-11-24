import lozad from 'lozad'
import { TweenMax } from 'gsap'

$ ->
	isForceLoad = false
	observer = lozad '.lozad',
		rootMargin: '1000px 0px',
		threshold: 0

	notMobileObserver = lozad '.not-mobile-lozad',
		rootMargin: '1000px 0px',
		threshold: 0

	videoObserver = lozad '.video-lozad',
		rootMargin: '500px 0px',
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
				el.play() if $this.closest('.product-cover.hover, .product-cover.active').length

	catalogVideoObserver = lozad '.catalog-lozad',
		rootMargin: '1000px 0px',
		threshold: 0,
		load: (el) ->
			$this = $(el)
			$video = $this.find('video')
			{ video, type } = $video.data()
			$image = $this.find('.product-cover__video-poster')
			{ src } = $image.data()

			# add video source
			tempSource = document.createElement('source')
			tempSource.src = video
			tempSource.type = type
			$video.get(0).appendChild tempSource

			# add bottle images
			$sliderImg = $this.parent().find('.product-cover__slider-image')
			$sliderImg.each ->
				@.src = $(@).data().src

			# add image background
			$image.css('background-image', "url(#{src})")

			handleCanPlayThrough = ->
				$video.addClass 'is-loaded'
				if --totalVideos == 0
					isForceLoad = false
					$(document).trigger 'videos-loaded'

				# force play
				$video.get(0).play() if $video.closest('.product-cover.hover, .product-cover.active').length
				TweenMax.to $image, 0.5, { autoAlpha: 0, delay: 1.5 }

				NProgress.inc(0.01) if window.location.pathname == '/' and isForceLoad

			$video.get(0).addEventListener 'canplaythrough', handleCanPlayThrough


	videoWasInit = false
	totalVideos = -1

	initLazyLoad = ->
		isForceLoad = false
		observer.observe()
		videoWasInit = false
		if !isMobile() and !touchDevice
			videoWasInit = true
			catalogVideoObserver.observe()
			videoObserver.observe()
			notMobileObserver.observe()

		controller.resizeSceneActions.push ->
			if !isMobile() and !videoWasInit and !touchDevice
				videoWasInit = true
				videoObserver.observe()
				catalogVideoObserver.observe()
				notMobileObserver.observe()

	forceLazyLoad = ->
		isForceLoad = true
		$('.lozad').each ->
			observer.triggerLoad @

		if videoWasInit
			totalVideos = $('.catalog-lozad').length
			$('.video-lozad').each -> videoObserver.triggerLoad @
			$('.catalog-lozad').each -> catalogVideoObserver.triggerLoad @

	initLazyLoad()

	$(document).on 'init-lazy-load', initLazyLoad
	$(document).on 'force-lazy-load', forceLazyLoad
