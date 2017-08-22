class Kijiji::Pages::Category < Navigator
  attr_reader :paging
  
  def initialize(uri:, filter: nil, paging: 1)
    raise ArgumentError.new("paging = #{paging}") unless paging.kind_of?(Integer) and paging >= 1
    @paging = paging

    path = uri.path.split(/\//)

    if paging > 1
      last = path.pop
      path += ["page-#{paging}", last]
    end

    uri.query = nil
    uri.path = path.join('/')
    uri = URI.parse(uri.to_s + filter) if filter

    super(uri: uri)
  end
  
  def ads
    page.search('div[data-ad-id]').map do |div|
      ad_uri = uri.dup
      ad_uri.query = nil
      ad_uri.path = div.attr('data-vip-url')
      Kijiji::Pages::Ad.new(uri: ad_uri)
    end
  end

  def valid?
    paging == 1 or !page.uri.to_s.match(%r{page-#{paging}}).nil?
  end
end