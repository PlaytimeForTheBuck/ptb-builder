require './cacher'
require 'fileutils'
require 'ptb_scrapper'

PtbScrapper.load_rake_tasks
PtbScrapper.init

SITE_PATH = File.expand_path './_site'

namespace :site do
  desc 'Builds the front end website with Jekylls'
  task :jekyll do
    frontend_path = Gem.loaded_specs['ptb_frontend'].full_gem_path
    config_file = File.join frontend_path, '_config_deployment.yml'
    system "jekyll build -s #{frontend_path} -d #{SITE_PATH} --config #{config_file}"
  end

  desc 'Renders the app on a headless browser and extract' +
       ' the table contents and saves a modified file, for the sake of SEO.'
  task :cache do
    cacher = Cacher.new
    cacher.save_rendered_table('index.html')
    puts 'Generated cached table'
  end

  desc 'Rename the summary file, games.json to add the md5 on the file name'
  task :copy_md5_summary do
    md5 = Digest::MD5.file('./db/games.json')
    origin_file = './db/games.json'
    destination_file_name = "games-#{md5}.json"
    destination_file = File.join(SITE_PATH, destination_file_name)
    FileUtils.copy origin_file, destination_file
    puts "Copied summary as md5 named file to _site #{destination_file_name}"
  end

  desc 'Add summary file md5 to index.html'
  task :inject_md5_summary do
    file_name = File.basename Dir.glob(File.join(SITE_PATH, 'games-*.json')).first
    index_file = File.join SITE_PATH, 'index.html'
    index_content = File.read(index_file)
    index_content = index_content.gsub(/games-db=".*"/, %Q{games-db="#{file_name}"})
    File.write index_file, index_content
    puts "Added md5 summary db file name to index.html #{file_name}"
  end
end

desc 'Push the Jekyll-generated website'
task :push_to_git do
  system 'cd _site && git add . && git add -u'
  system 'cd _site && git push origin master'
end

desc 'Generate the _site with all the things'
task generate_site: ['site:jekyll', 'site:cache', 'site:copy_md5_summary', 'site:inject_md5_summary']

desc 'Scrap everything'
task scrap: ['scrapper:games_list', 'scrapper:games', 'scrapper:reviews', 'scrapper:summary']

desc 'Scrap, build, cache, copy, commit and push!'
task :cronjob => [:scrap, :generate_site, :push_to_git]