require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'webrick'
require 'nokogiri'
require 'yaml'

class Cacher
  PORT = 9999
  PHANTOM_SCRIPT = File.expand_path './cacher.coffee'

  def webserver
    @thread ||= begin
      Thread.new do
        WEBrick::HTTPServer.new(:Port => PORT, 
                                :DocumentRoot => SITE_PATH,
                                :AccessLog => []).start
      end
    end
    sleep 1 # I'm not sure how to check if WEBBrick already loaded. And this is probably easier.
    # @thread.join
  end

  def save_rendered_page(page)
    webserver

    # source_file = File.open(File.join(SITE_PATH, page), 'r')
    # doc = Nokogiri::HTML source_file.read
    # container = doc.at_css page_container
    # source_file.close

    Dir.glob("#{SITE_PATH}/**/index.html").each do |route_file_name|
      relative_route_file_name = route_file_name.sub(__dir__, '')
      route_address_match = route_file_name.match(/_site(\/.*|)\/index\.html/)[1]
      url = "http://localhost:#{PORT}#{route_address_match}/#!"

      puts "Loading Phantom page #{url}"
      page_content = `phantomjs cacher.coffee #{url}`
      puts "Received rows from PhantomJS for page #{relative_route_file_name}"
      output_file = File.open(route_file_name, 'w')
      output_file.write page_content
      output_file.close

      puts 'Rendered page saved to disk'
    end
  end
end