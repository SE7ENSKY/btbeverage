import NProgress from 'nprogress'

NProgress.configure { showSpinner: false, trickle: false, minimum: 0.01 }
window.NProgress = NProgress

window.addEventListener 'load', ->
	NProgress.remove()

$ ->
	NProgress.remove()
