import { TweenMax, Power2 } from 'gsap'

$ ->
	scroll2Id = ->
		$idLinks = $("a[href^='#']")
		return unless $idLinks.length

		$idLinks.on 'click', (ev) ->
			ev.preventDefault()
			$this = $(@)
			target = $this.attr 'href'
			$target = $(target)
			return unless $target.length
			return if $('body').css('overflow') == 'hidden'

			duration = 0.3 * (Math.abs($this.offset().top - $target.offset().top) / window.innerHeight)

			TweenMax.to $(window), duration,
				scrollTo:
					y: $target.offset().top
					autoKill: true
				ease: Power2.easeOut 

	# scroll2Id()
	#
	# $(document).on 'init-scroll2id', scroll2Id
