const NODE_ENV = process.env.NODE_ENV || 'development';
const enableProfiling = process.env.ENABLE_PROFILING === 'true';
const path = require("path");
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

let config = {
    mode: NODE_ENV,
    devtool: NODE_ENV === 'development' ? 'source-map' : false,
    entry: {
        main: "./assets/jsx/index.jsx",
    },
    output: {
        path: path.join(__dirname, "assets", "js"),
        filename: NODE_ENV === 'production' ? "[name].min.js" : "[name].js"
    },
    resolve: {
        extensions: ['.js', '.jsx']
    },
    module: {
        rules: [
            {
                test: /\.(jsx)$/, // Identifies which file or files should be transformed.
                use: {loader: "babel-loader"}, //
                exclude: [
                    /(node_modules|bower_components)/,
                ]// JavaScript files to be ignored.
            },
            {
                test: /\.css$/i,
                use: ["style-loader", "css-loader", "postcss-loader"],
            }
        ]
    },
    optimization: {
        minimize: NODE_ENV === 'production',
    },
    externals: {
        "react": "React",
        "react-dom": "ReactDOM",
        "@wordpress/element": "wp.element",
        "@wordpress/components": "wp.components",
        "@wordpress/data": "wp.data",
        "@wordpress/plugins": "wp.plugins",
        "@wordpress/hooks": "wp.hooks",
        "@wordpress/url": "wp.url",
        "@wordpress/i18n": "wp.i18n",
        'wp': 'wp'
    },
};

if (enableProfiling) {
    if (! config.plugins) {
        config.plugins = [];
    }

    config.plugins.push(new BundleAnalyzerPlugin({
        analyzerMode: 'static',
        reportFilename: 'webpack-bundle-stats.html',
    }));
}

module.exports = config;
