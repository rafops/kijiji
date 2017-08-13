require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'kijiji'
require 'pry'

config = YAML.load(File.read('config.yml'))
home_page = Kijiji::Pages::Home.new(uri: URI.parse(config['url']))
category_page = home_page.category(category: %r{#{config['category']}})

paging = 1
paging_max = config['paging_max']
filter = "r#{config['radius']}" +
         "?ad=#{config['ad']}" +
         "&price=#{config['price_min']}__#{config['price_max']}" +
         "&furnished=#{config['furnished']}"
ads = []

loop do
  category_page = Kijiji::Pages::Category.new(
    uri: category_page.uri,
    filter: filter,
    paging: paging
  )
  break unless category_page.valid?
  ads += category_page.ads

  paging += 1
  break if paging > paging_max
end

ads.each do |ad|
  if Kijiji::DB::Ad.new(ad.to_h).insert
    STDOUT.puts ad
    STDERR.print '*'
  else
    STDERR.print '.'
  end
end
STDERR.print "\n"

exit(0)