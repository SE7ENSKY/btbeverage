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
import 'fonts/ffmark/stylesheet.css';
import 'styles/main.styl';

// ------------------ import vendor scripts ------------------
import 'vendor/modernizr.js';
import 'vendor/twitter-bootstrap/transition.js';
import 'vendor/twitter-bootstrap/modal.js';
import 'imports-loader?define=>false!scrollmagic/scrollmagic/uncompressed/plugins/animation.gsap';
import 'imports-loader?define=>false!scrollmagic/scrollmagic/uncompressed/plugins/debug.addIndicators';

// ----------------- import system scripts -------------------
import 'scripts/main.coffee';

// ------------------ import system blocks -------------------
getRequiredfiles(require.context('../blocks/', true, /\.(css|styl|less|sass|scss)$/));
getRequiredfiles(require.context('../blocks/', true, /\.(js|coffee)$/));
