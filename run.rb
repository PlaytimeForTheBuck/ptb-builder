require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'webrick'
require 'phantomjs'
require 'nokogiri'

PORT = 9999
WEB_ROOT = File.expand_path '../frontend/_site'

thread = Thread.new {
  WEBrick::HTTPServer.new(:Port => PORT, 
                          :DocumentRoot => WEB_ROOT,
                          :AccessLog => [],
                          :Logger => WEBrick::Log::new("/dev/null", 7)).start
}

sleep 0.5

def save_rendered_table(page)
  rows_container = 'tbody'
  rows = Phantomjs.run('./phantom.coffee', "http://localhost:#{PORT}#autorender", rows_container)
  puts "Received rows from PhantomJS for page #{page}"

  file_name = File.join(WEB_ROOT, page)
  File.open(file_name, 'r+') do |file|
    doc = Nokogiri::HTML file.read
    container = doc.at_css rows_container
    container.inner_html = rows
    file.rewind
    file.write doc.to_html
    file.flush
    file.truncate file.pos
    puts "Rendered table saved to disk"
  end
end

save_rendered_table('index.html')

thread.join