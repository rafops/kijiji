require 'rubygems'
require 'bundler/setup'

require 'pry'

require 'yaml'
require 'kijiji'

config = YAML.load(File.read('config.yml'))

home_page = Kijiji::Pages::Home.new(uri: URI.parse(config['url']))
category_page = home_page.category(category: %r{#{config['category']}})

paging = 1
paging_max = config['paging_max']
filter = "r#{config['radius']}?" +
         "ad=#{config['ad']}&" +
         "price=#{config['price_min']}__#{config['price_max']}&" +
         "for-rent-by=#{config['for_rent_by']}&" +
         "furnished=#{config['furnished']}"
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
  output = []
  output << ad.postal_code.to_s.ljust(7)
  output << ('%.2f' % (ad.price || 0)).ljust(7)
  output << ad.phone.to_s.ljust(17)
  output << ad.age_in_hours.to_s.ljust(4)
  output << ad.uri
  STDOUT.puts output.join("\t")
end

exit(0)