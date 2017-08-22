require 'singleton'

class Configurator
  include Singleton

  def initialize
    config_path = File.join(File.dirname(__FILE__), '../config.yml')
    @config = YAML.load(File.read(config_path))
  end

  def [](k)
    @config[k]
  end
end
