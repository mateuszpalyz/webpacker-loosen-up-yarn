require "webpacker/node_bundler"

node_bundler = Webpacker::NodeBundler.command
node_bundler_dev = Webpacker::NodeBundler.command_dev

# Install webpacker
copy_file "#{__dir__}/config/webpacker.yml", "config/webpacker.yml"

puts "Copying webpack core config and loaders"
directory "#{__dir__}/config/webpack", "config/webpack"
directory "#{__dir__}/config/loaders/core", "config/webpack/loaders"

puts "Copying .postcssrc.yml to app root directory"
copy_file "#{__dir__}/config/.postcssrc.yml", ".postcssrc.yml"

puts "Copying .babelrc to app root directory"
copy_file "#{__dir__}/config/.babelrc", ".babelrc"

puts "Creating javascript app source directory"
directory "#{__dir__}/javascript", "#{Webpacker::Configuration.source}"

puts "Copying binstubs"
directory "#{__dir__}/bin", "bin"

chmod "bin", 0755 & ~File.umask, verbose: false

if File.exists?(".gitignore")
  append_to_file ".gitignore", <<-EOS
/public/packs
/public/packs-test
/node_modules
EOS
end

puts "Installing all JavaScript dependencies"
run "#{node_bundler} webpack webpack-merge js-yaml path-complete-extname " \
"webpack-manifest-plugin babel-loader@7.x coffee-loader coffee-script " \
"babel-core babel-preset-env babel-polyfill compression-webpack-plugin rails-erb-loader glob " \
"extract-text-webpack-plugin node-sass file-loader sass-loader css-loader style-loader " \
"postcss-loader postcss-cssnext postcss-smart-import resolve-url-loader " \
"babel-plugin-syntax-dynamic-import babel-plugin-transform-class-properties " \
"babel-plugin-transform-object-rest-spread"

puts "Installing dev server for live reloading"
run "#{node_bundler_dev} webpack-dev-server"

puts "Webpacker successfully installed 🎉 🍰"
