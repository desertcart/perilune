// import esbuild from "esbuild";

const esbuild = require('esbuild');
const {sassPlugin} = require('esbuild-sass-plugin');
const postcss = require('postcss');
const postcssImport = require('postcss-import');
const tailwindcssNesting = require('tailwindcss/nesting');
const tailwindcss = require('tailwindcss');
const autoprefixer = require('autoprefixer');
const chokidar = require('chokidar');

const watchDirectories = [
    "./app/**/*.html.erb",
    "./app/**/*.html.haml",
];

const config = {
    entryPoints: [
        "app/javascript/perilune.js",
        "app/javascript/perilune_css.js"
    ],
    outdir: "app/assets/builds",
    absWorkingDir: process.cwd(),
    bundle: true,
    sourcemap: process.argv.includes("--watch"),
    incremental: process.argv.includes("--watch"),
    watch: process.argv.includes("--watch"),
    logLevel: 'debug',
    plugins: [
        sassPlugin({
            async transform(source, resolveDir) {
                const {css} = await postcss([
                    postcssImport,
                    tailwindcss,
                    autoprefixer
                ]).process(source)
                return css
            }
        }),
    ],
}

if (process.argv.includes("--watch")) {
    (async () => {
        await esbuild.build(config);
        chokidar.watch(watchDirectories).on('all', (event, path) => {
            if (event === 'change') {
                esbuild.build(config)
            }
        })
    })();

} else {
    esbuild.build(config).catch(() => process.exit(1))
}
