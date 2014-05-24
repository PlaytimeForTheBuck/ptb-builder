require './cacher'

SITE_PATH = File.expand_path './_site'

desc 'Builds the front end website with Jekylls'
task :build_jekyll do
  frontend_path = Gem.loaded_specs['ptb_frontend'].full_gem_path
  exec "jekyll build -s #{frontend_path} -d #{SITE_PATH}"
end

desc 'Renders the app on a headless browser and extract' +
     ' the table contents and saves a modified file, for the sake of SEO.'
task :cache do
  cacher = Cacher.new
  cacher.save_rendered_table 'index.html'
end