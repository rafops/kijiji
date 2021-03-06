class Kijiji::Pages::Ad < Navigator
  def location
    @location ||= lambda {
      span = page.search("//span[contains(@class, 'address-')]").first
      span.text if span      
    }.call
  end

  def postal_code_6
    @postal_code_6 ||= lambda {
      return unless location
      postal_code = location.match(/([A-Z][\d][A-Z])[^\d]{0,1}([\d][A-Z][\d])/)
      postal_code[1..2].join('') if postal_code
    }.call
  end

  def postal_code
    return unless postal_code_6
    @postal_code ||= postal_code.split(/(?<=\G...)/).join(' ')
  end

  def description
    @description ||= lambda {
      description = page.search("//div[contains(@class, 'descriptionContainer-')]").first
      description.text if description
    }.call
  end

  def phone
    @phone ||= lambda {
      return unless description
      phone = description.match(/(416|647|437)[^\d]{0,2}([\d]{3})[^\d]{0,1}([\d]{4})/)
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
      span = page.search("//span[contains(@class, 'currentPrice-')]").first
      return unless span
      price_match = span.text.match(/\$([\d,]+)\.([\d]+)/)
      return unless price_match
      amount, cents = price_match[1..2]
      amount.gsub(/[^\d]/, '').to_i + (cents.to_i / 100.0)
    }.call
  end

  def price_round
    return unless price
    @price_round ||= price.round
  end
  
  def published
    @published ||= lambda {
      time = page.search("time[title]").first
      return unless time
      match = time.attr('title').match(/([\w]+)\s+([\d]+),\s+([\d]+)\s+([\d]+):([\d]+)\s+([APM]{2})/)
      return unless match
      DateTime.strptime((match[1..3] + ['%2d' % match[4]] + match[5..6]).join("\t"), "%B\t%d\t%Y\t%l\t%M\t%p")
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