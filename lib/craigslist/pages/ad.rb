require 'digest'

class Craigslist::Pages::Ad < Craigslist::Pages::Base
  def location
    @location ||= lambda {
      div = page.search('div.mapaddress')
      div.text if div
    }.call
  end

  def postal_code_6
    @postal_code_6 ||= lambda {
      return unless location
      postal_code = page.body.match(/([A-Z][\d][A-Z])[\s]{0,1}([\d][A-Z][\d])/)
      postal_code[1..2].join('') if postal_code
    }.call
  end

  def postal_code
    return unless postal_code_6
    @postal_code ||= postal_code.split(/(?<=\G...)/).join(' ')
  end

  def phone
    @phone ||= lambda {
      phone = page.body.match(/(416|647|437)[^\d]{0,2}([\d]{3})[^\d]{0,1}([\d]{4})/)
      return unless phone
      "+1 (#{phone[1]}) #{phone[2]}-#{phone[3]}"
    }.call
  end

  def phone_number
    return unless phone
    @phone_number ||= phone.gsub(/[^\d]/, '').to_i
  end

  def price
    @price ||= lambda {
      span = page.search('span.price').first
      return unless span
      price_match = span.text.match(/([\d,]+)/)
      return unless price_match
      price_match[1].to_i / 1.0
    }.call
  end

  def price_round
    return unless price
    @price_round ||= price.round
  end
  
  def published
    @published ||= lambda {
      time = page.search("time.timeago").first
      return unless time
      DateTime.parse(time.attr('datetime'))
    }.call
  end

  def published_time
    return unless published
    @published_time ||= published.strftime('%s').to_i
  end

  def age_in_hours
    return unless published
    (Time.now.utc.to_i - published_time) / 3600
  end

  def url
    uri.to_s
  end

  def to_s
    output = []
    output << postal_code_6.to_s.ljust(6)
    output << price_round.to_s.rjust(11)
    output << phone.to_s.ljust(17)
    output << age_in_hours.to_s.rjust(4)
    output << url
    output.join("\t")
  end

  def to_h
    {
      'postal_code_6'  => postal_code_6,
      'phone_number'   => phone_number,
      'price'          => price,
      'published_time' => published_time,
      'url'            => url
    }
  end
end