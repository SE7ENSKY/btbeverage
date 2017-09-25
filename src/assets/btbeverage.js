if (module.hot) {
	const originalLog = console.log;
	console.log = function () {
		if (arguments[0].toString().indexOf('[HMR]') === -1) {
			return originalLog.apply(console, arguments);
		}
	};
	module.hot.accept();
}

const getRequiredfiles = file => file.keys().forEach(file);

// ------------------ import vendor styles -------------------
import 'normalize.css/normalize.css';
import 'flickity/dist/flickity.css';

// ------------------ import system styles -------------------
import 'f/ffmark/stylesheet.css';
import 'styles/main.styl';

// ------------------ import vendor scripts ------------------
import 'vendor/twitter-bootstrap/transition.js';
import 'vendor/twitter-bootstrap/modal.js';
import 'vendor/pixi/pixi.min.js';
import 'imports-loader?define=>false!scrollmagic/scrollmagic/uncompressed/plugins/animation.gsap';
import 'imports-loader?define=>false!scrollmagic/scrollmagic/uncompressed/plugins/debug.addIndicators';
import 'imports-loader?define=>false!gsap/ScrollToPlugin';

// ----------------- import system scripts -------------------
import 'scripts/main.coffee';
import 'scripts/sequenceAnimation.coffee';
import 'scripts/addVideo.coffee';
import 'scripts/barba.coffee';
import 'scripts/pixi.coffee';
import 'scripts/slowScroll.coffee';

// ------------------ import system blocks -------------------
getRequiredfiles(require.context('../blocks/', true, /\.(css|styl|less|sass|scss)$/));
getRequiredfiles(require.context('../blocks/', true, /\.(js|coffee)$/));
