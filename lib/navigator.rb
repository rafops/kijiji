require 'uri'
require 'mechanize'

class Navigator
  attr_reader :uri, :agent
  
  def initialize(uri:)
    raise ArgumentError.new("uri = #{uri}") unless uri.kind_of?(URI)
    @uri = uri
    @reject = config['reject'].to_s.split(/,/)
    @accept = config['accept'].to_s.split(/,/)
    @agent = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
    end
  end

  def reject?
    @reject.any? { |r| body.match %r{#{r}}i }
  end

  def accept?
    @accept.any? { |r| body.match %r{#{r}}i }
  end

  protected

    def page
      @page ||= agent.get(uri)
    end

    def body
      @body ||= page.body
    end

    def config
      Configurator.instance
    end
end