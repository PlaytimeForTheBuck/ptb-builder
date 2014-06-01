require './cacher'
require 'fileutils'
require 'ptb_scrapper'

PtbScrapper.load_rake_tasks

PtbScrapper.setup do |config|

end

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
  cacher.save_rendered_table('index.html')
end

desc 'Scrap games, then reviews and then categories'
task :scrap_everything => [:scrap_games, :scrap_categories, :scrap_reviews]

desc 'Rename the summary file, games.json to add the md5 on the file name, and replace the name on index.html'
task :md5_summary do

end

desc 'Commit the Jekyll-generated website'
task :commit_site do

end

desc 'Push the Jekyll-generated website'
task :push_site do

end

desc 'Scrap, build, cache, copy, commit and push!'
task :cronjob => [:scrap_everything, :build_jekyll, :cache, :copy_cache, :copy_scrapped, :commit_site, :push_site]