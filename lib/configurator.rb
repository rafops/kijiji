require 'singleton'

class Configurator
  include Singleton

  def initialize
    config_file = ENV['KIJIJI_CONFIG_FILE'] || 'config.yml'
    config_path = File.join(File.dirname(__FILE__), "../#{config_file}")
    @config = File.exists?(config_path) ? YAML.load(File.read(config_path)) : {}
    @config.each do |k,v|
      @config[k] = ENV[k.upcase] if ENV[k.upcase]
    end
  end

  def [](k)
    @config[k]
  end
end
