require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'webrick'
require 'phantomjs'
require 'nokogiri'

class Cacher
  PORT = 9999
  PHANTOM_SCRIPT = File.expand_path './cacher.coffee'

  def webserver
    @thread ||= begin
      Thread.new do
        WEBrick::HTTPServer.new(:Port => PORT, 
                                :DocumentRoot => SITE_PATH,
                                :AccessLog => [],
                                :Logger => WEBrick::Log::new("/dev/null", 7)).start
      end
    end
    sleep 0.5 # I'm not sure how to check if WEBBrick already loaded. And this is probably easier.
    @thread
  end
  
  def save_rendered_table(page)
    webserver

    rows_container = 'tbody'
    rows = Phantomjs.run(PHANTOM_SCRIPT, "http://localhost:#{PORT}#autorender", rows_container)
    puts "Received rows from PhantomJS for page #{page}"

    file_name = File.join(SITE_PATH, page)

    source_file = File.open(file_name, 'r')

    doc = Nokogiri::HTML source_file.read
    container = doc.at_css rows_container
    container.inner_html = rows

    source_file.close
    output_file = File.open(file_name, 'w')
    output_file.write doc.to_html
    output_file.close

    puts 'Rendered table saved to disk'
  end
end