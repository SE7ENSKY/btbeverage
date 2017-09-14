import { TimelineMax, Power0 } from 'gsap'

$ ->
	$block = $(".product-cover")
	return unless $block.length
	$catalog = $(".catalog")

	$block.on "click", (e) ->
		$this = $(@)
		tl = new TimelineMax()
		$target = $catalog.find($this.attr("data-target"))
		$targetInner = $target.find('.product-params__inner')

		productCoverHeightClosed = 0.33 * window.innerWidth
		productCoverHeightOpen = Math.max(150 + $targetInner.outerHeight(), 0.33 * window.innerWidth)

		diff = 0.33 * window.innerWidth + $targetInner.outerHeight() - productCoverHeightOpen

		catalogIndex = $('.catalog__item').index($this.parent()) + 1
		selector = ".catalog__item:nth-child(2n+#{catalogIndex + 2})"

		if !$this.hasClass('active')
			coverHeight = $this.innerHeight()
			tl
				.fromTo $target.get(0), 0.5, { height: 0 }, { height: $targetInner.outerHeight(),ease: Power0.easeNone  }, 0
				.fromTo $this.get(0), 0.5, { paddingBottom: "#{productCoverHeightClosed}px" }, { paddingBottom: "#{productCoverHeightOpen}px", ease: Power0.easeNone }, 0
				.staggerFromTo selector, 0.5, { y: 0 }, { y: -diff, ease: Power0.easeNone }, 0, 0
		else
			tl
				.to $target.get(0), 0.5, { height: 0, ease: Power0.easeNone }, 0
				.to $this.get(0), 0.5, { paddingBottom: "#{productCoverHeightClosed}px" , ease: Power0.easeNone  }, 0
				.set $this.get(0), { paddingBottom: "66%" }, 0.5
				.staggerFromTo selector, 0.5, { y: -diff }, { y: 0, ease: Power0.easeNone }, 0, 0

		$this.toggleClass 'active'
