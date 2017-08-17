require 'uri'
require 'mechanize'

module Craigslist
  module Pages
    class Base
      attr_reader :uri, :agent
      
      def initialize(uri:)
        raise ArgumentError.new("uri = #{uri}") unless uri.kind_of?(URI)
        @uri = uri
        @agent = Mechanize.new do |agent|
          agent.user_agent_alias = 'Mac Safari'
        end
      end

      protected

        def page
          @page ||= agent.get(uri)
        end
    end
  end
end

require_relative 'pages/category'
require_relative 'pages/ad'