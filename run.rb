require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'webrick'
require 'phantomjs'
require 'nokogiri'

PORT = 9999
WEB_ROOT = File.expand_path '../frontend/_site'
CACHE_PATH = File.expand_path './cached'

thread = Thread.new {
  WEBrick::HTTPServer.new(:Port => PORT, 
                          :DocumentRoot => WEB_ROOT,
                          :AccessLog => [],
                          :Logger => WEBrick::Log::new("/dev/null", 7)).start
}

sleep 0.5 # I'm not sure how to check if WEBBrick already loaded. And this is probably easier.

def save_rendered_table(page)
  rows_container = 'tbody'
  rows = Phantomjs.run('./phantom.coffee', "http://localhost:#{PORT}#autorender", rows_container)
  puts "Received rows from PhantomJS for page #{page}"

  Dir.mkdir CACHE_PATH unless Dir.exists? CACHE_PATH

  source_file_name = File.join(WEB_ROOT, page)
  output_file_name = File.join(CACHE_PATH, page)

  source_file = File.open(source_file_name, 'r')
  output_file = File.open(output_file_name, 'w')

  doc = Nokogiri::HTML source_file.read
  container = doc.at_css rows_container
  container.inner_html = rows

  output_file.write doc.to_html

  source_file.close
  output_file.close

  puts 'Rendered table saved to disk'
end

save_rendered_table('index.html')

#thread.stop