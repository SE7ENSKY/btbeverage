if (process.env.TIMESTAMP) {
	require('console-stamp')(console, {
		pattern: 'HH:MM:ss',
		label: false
	});
}

const { join } = require('path');
const nib = require('nib');
const cssMQpacker = require('css-mqpacker');
const perfectionist = require('perfectionist');
const cssNano = require('cssnano');
const {
	NoEmitOnErrorsPlugin,
	ProvidePlugin,
	WatchIgnorePlugin,
	DefinePlugin,
	optimize: {
		UglifyJsPlugin,
		CommonsChunkPlugin
	}
} = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const BeautifyHtmlPlugin = require('beautify-html-plugin');
const ScriptExtHtmlWebpackPlugin = require('script-ext-html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const StylesPostprocessorPlugin = require('styles-postprocessor-plugin');
const HappyPack = require('happypack');
const happyThreadPool = HappyPack.ThreadPool({ size: 4 });
const {
	PROJECT_ROOT,
	PROD_OUTPUT,
	POSTCSS_CONFIG,
	SUPPORTED_BROWSERS_LIST,
	CSS_NANO_BASE_CONFIG,
	CSS_NANO_MINIMIZE_CONFIG,
	PERFECTIONIST_CONFIG,
	generateEntry,
	gererateVendor,
	getModifiedNib,
	initHtmlWebpackPlugin
} = require('../bin/utils');


const stylesPostprocessorConfig = {
	root: PROJECT_ROOT,
	output: PROD_OUTPUT,
	plugins: [
		cssMQpacker(),
		cssNano(
			Object.assign(
				CSS_NANO_BASE_CONFIG,
				process.env.UGLIFY ? CSS_NANO_MINIMIZE_CONFIG : {}
			)
		)
	]
};

if (!process.env.UGLIFY) {
	stylesPostprocessorConfig.plugins.push(perfectionist(PERFECTIONIST_CONFIG));
}

const fileLoaderExclude = [
	join(PROJECT_ROOT, 'node_modules'),
	join(PROJECT_ROOT, 'src', 'vendor')
];
const urlLoaderInclude = fileLoaderExclude;

const postcssLoaderOptions = {
	sourceMap: false,
	config: {
		path: POSTCSS_CONFIG,
		ctx: {
			cssnext: {
				autoprefixer: {
					browsers: SUPPORTED_BROWSERS_LIST
				}
			}
		}
	}
};

const prodConfig = {
	context: join(PROJECT_ROOT, 'src'),
	entry: generateEntry(),
	output: {
		path: PROD_OUTPUT,
		publicPath: '/',
		filename: `assets/[name]${process.env.UGLIFY ? '.min' : ''}.[chunkhash:8].js`
	},
	resolve: {
		extensions: [
			'.js',
			'.coffee',
			'.yaml',
			'.json',
			'.css',
			'.sass',
			'.scss',
			'.less',
			'.styl',
			'.png',
			'.jpg',
			'.jpeg',
			'.gif'
		],
		alias: {
			fonts: join(PROJECT_ROOT, 'src', 'assets', 'fonts'),
			img: join(PROJECT_ROOT, 'src', 'assets', 'img'),
			scripts: join(PROJECT_ROOT, 'src', 'assets', 'scripts'),
			styles: join(PROJECT_ROOT, 'src', 'assets', 'styles'),
			vendor: join(PROJECT_ROOT, 'src', 'vendor')
		}
	},
	devtool: false,
	target: 'web',
	watch: false,
	module: {
		rules: [
			{
				test: /\.(jpg|png|gif|eot|ttf|woff|woff2|svg)$/,
				include: urlLoaderInclude,
				use: 'happypack/loader?id=url'
			},
			{
				test: /\.(jpg|png|gif|eot|ttf|woff|woff2|svg|mp4|webm)$/,
				exclude: fileLoaderExclude,
				use: 'happypack/loader?id=file'
			},
			{
				test: /\.json$/,
				use: 'happypack/loader?id=json'
			},
			{
				test: /\.yaml$/,
				use: 'happypack/loader?id=yaml'
			},
			{
				test: /\.md$/,
				use: 'happypack/loader?id=markdown'
			},
			{
				test: /\.html$/,
				use: 'happypack/loader?id=html'
			},
			{
				test: /\.coffee$/,
				use: 'happypack/loader?id=coffeescript'
			},
			{
				test: /\.js$/,
				exclude: /node_modules/,
				use: 'happypack/loader?id=babel'
			},
			{
				test: /\.css$/,
				use: ExtractTextPlugin.extract({
					use: 'happypack/loader?id=css',
					fallback: ['style-loader']
				})
			},
			{
				test: /\.(sass|scss)$/,
				use: ExtractTextPlugin.extract({
					use: 'happypack/loader?id=sass',
					fallback: ['style-loader']
				})
			},
			{
				test: /\.less$/,
				use: ExtractTextPlugin.extract({
					use: 'happypack/loader?id=less',
					fallback: ['style-loader']
				})
			},
			{
				test: /\.styl$/,
				use: ExtractTextPlugin.extract({
					use: 'happypack/loader?id=stylus',
					fallback: ['style-loader']
				})
			}
		]
	},
	plugins: [
		new DefinePlugin({
			'process.env': {
				NODE_ENV: JSON.stringify(process.env.NODE_ENV)
			}
		}),
		new ExtractTextPlugin({
			filename: `assets/[name]${process.env.UGLIFY ? '.min' : ''}.[chunkhash:8].css`,
			allChunks: true
		}),
		new HappyPack({
			id: 'markdown',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: [
				'html-loader',
				'markdown-loader'
			]
		}),
		new HappyPack({
			id: 'html',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: ['html-loader']
		}),
		new HappyPack({
			id: 'css',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: [
				'css-loader',
				{
					path: 'postcss-loader',
					query: postcssLoaderOptions
				}
			]
		}),
		new HappyPack({
			id: 'sass',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: [
				'css-loader',
				{
					path: 'postcss-loader',
					query: postcssLoaderOptions
				},
				{
					path: 'sass-loader',
					query: {
						sourceMap: false
					}
				}
			]
		}),
		new HappyPack({
			id: 'less',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: [
				'css-loader',
				{
					path: 'postcss-loader',
					query: postcssLoaderOptions
				},
				{
					path: 'less-loader',
					query: {
						sourceMap: false
					}
				}
			]
		}),
		new HappyPack({
			id: 'stylus',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: [
				'css-loader',
				{
					path: 'postcss-loader',
					query: postcssLoaderOptions
				},
				{
					path: 'stylus-loader',
					query: {
						sourceMap: false,
						use: nib(),
						import: [
							join(PROJECT_ROOT, 'src', 'globals', 'variables.styl'),
							join(PROJECT_ROOT, 'src', 'globals', 'mixins.styl'),
							getModifiedNib(require.resolve('verstat-nib'))
						],
						preferPathResolver: 'webpack'
					}
				}
			]
		}),
		new HappyPack({
			id: 'yaml',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: ['yaml-loader']
		}),
		new HappyPack({
			id: 'json',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: ['json-loader']
		}),
		new HappyPack({
			id: 'coffeescript',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: ['coffee-loader']
		}),
		new HappyPack({
			id: 'url',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: ['url-loader']
		}),
		new HappyPack({
			id: 'file',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: ['file-loader']
		}),
		new HappyPack({
			id: 'babel',
			verbose: false,
			threadPool: happyThreadPool,
			loaders: [{
				path: 'babel-loader',
				query: {
					cacheDirectory: true,
					babelrc: false,
					plugins: ['transform-runtime'],
					presets: [
						[
							'env',
							{
								targets: {
									browsers: SUPPORTED_BROWSERS_LIST
								},
								modules: false,
								loose: true,
								useBuiltIns: true
							}
						]
					]
				}
			}]
		}),
		new ScriptExtHtmlWebpackPlugin({
			defaultAttribute: 'defer'
		}),
		new NoEmitOnErrorsPlugin(),
		new ProvidePlugin({
			$: 'jquery',
			jQuery: 'jquery',
			'window.jQuery': 'jquery'
		}),
		new CommonsChunkPlugin({
			name: gererateVendor(),
			filename: `assets/${gererateVendor()}${process.env.UGLIFY ? '.min' : ''}.[chunkhash:8].js`,
			minChunks: (module, count) => (/node_modules/.test(module.resource) || /vendor/.test(module.resource)) && count >= 1
		}),
		new CopyWebpackPlugin([
			{
				from: 'assets',
				to: 'assets',
				ignore: [
					'scripts/*',
					'styles/*',
					'*.js',
					'.DS_Store'
				]
			}
		]),
		new WatchIgnorePlugin([join(PROJECT_ROOT, 'node_modules')]),
		new BeautifyHtmlPlugin({ ocd: true }),
		new StylesPostprocessorPlugin(stylesPostprocessorConfig),
		...initHtmlWebpackPlugin(PROD_OUTPUT)
	]
};

if (process.env.UGLIFY) {
	prodConfig.plugins.push(new UglifyJsPlugin({
		sourceMap: true,
		mangle: {
			screw_ie8: true
		},
		comments: false,
		compress: {
			screw_ie8: true,
			warnings: false
		}
	}));
}

module.exports = prodConfig;
