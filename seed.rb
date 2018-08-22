require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'configurator'
require 'navigator'
require 'db'
require 'kijiji'
require 'craigslist'
require 'pry'

config = Configurator.instance

## KIJIJI

home_page = Kijiji::Pages::Home.new(uri: URI.parse(config['url']))
category_page = home_page.category(category: %r{#{config['category']}})

filter = "r#{config['radius']}" +
         "?ad=#{config['ad']}" +
         "&price=#{config['price_min']}__#{config['price_max']}" +
         "&address=#{config['address']}" +
         "&ll=#{config['latitude']},#{config['longitude']}" +
         "&furnished=#{config['furnished']}"

paging = 1
paging_max = config['paging_max']

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
  if ad.reject?
    STDERR.print 'x'
  elsif DB::Ad.new(ad.to_h).insert
    if (ad.age_in_hours.to_i) <= config['reject_older_than'].to_i
      STDOUT.puts ad
    else
      STDERR.print '#'
    end
  elsif ad.accept?
    STDOUT.puts ad
    STDERR.print '@'
  else
    STDERR.print '.'
  end
end
STDERR.print "\n"

exit(0)