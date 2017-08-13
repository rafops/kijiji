class Kijiji::Pages::Home < Kijiji::Pages::Base
  def initialize(uri:)
    super(uri: uri)
  end

  def category(category:)
    Kijiji::Pages::Category.new(uri: URI.join(uri, page.link_with(text: category).uri))
  end
end