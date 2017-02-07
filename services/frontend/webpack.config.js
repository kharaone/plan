var path = require('path');
const webpack = require('webpack');

const sourcePath = path.join(__dirname, './src');
const staticsPath = path.join(__dirname, './static');

module.exports = function (env) {
    return {
        devtool: 'eval',
        context: sourcePath,
        entry: {
            js: './index.jsx',
            vendor: ['react']
        },
        output: {
            path: staticsPath,
            filename: '[name].bundle.js',
        },
        module: {
            rules: [
                {
                    test: /\.(js|jsx)$/,
                    exclude: /node_modules/,
                    use: [
                        {
                            loader: 'babel-loader',
                            query: {
                                presets: [
                                    ['es2015', { "modules": false }],
                                    'stage-2',
                                    'react'
                                ],
                                cacheDirectory: true
                            }
                        }
                    ]
                },
                {
                    test: /\.css$/,
                    use: ['style-loader', 'css-loader']
                }
            ]
        },
        resolve: {
            extensions: ['.webpack-loader.js', '.web-loader.js', '.loader.js', '.js', '.jsx'],
            modules: [
                path.resolve(__dirname, 'node_modules'),
                sourcePath
            ]
        },
        plugins: [
            new webpack.optimize.CommonsChunkPlugin({
                name: 'vendor',
                minChunks: Infinity,
                filename: 'vendor.bundle.js'
            }),
            new webpack.DefinePlugin({
                '__API_PROTOCOL__': `'${process.env.API_PROTOCOL}'`,
                '__API_HOST__': `'${process.env.API_HOST}'`,
                '__API_PORT__': `'${process.env.API_PORT}'`
            })
        ],
        devServer: {
            contentBase: './src',
            port: 8080,
            compress: false,
            inline: true,
            hot: false,
            stats: {
                assets: true,
                children: false,
                chunks: false,
                hash: false,
                modules: false,
                publicPath: false,
                timings: true,
                version: false,
                warnings: true,
                colors: {
                    green: '\u001b[32m',
                }
            },
        }
    }
}