require "yaml"

class Eventify::Configuration
  PATH = File.expand_path(File.join(ENV["HOME"], "/.eventify/config.yaml"))

  def initialize(configuration = {})
    @configuration = default_configuration.merge(load).merge(configuration)
  end

  def save
    File.open(PATH, "w") { |f| f.write YAML.dump(@configuration) }
  end

  def [](key)
    @configuration[key]
  end

  private

  def default_configuration
    {
      subscribers: ["user@example.org"],
      mail: Mail.delivery_method.settings
    }
  end

  def load
    YAML.load(File.read(PATH)) rescue {}
  end

end
