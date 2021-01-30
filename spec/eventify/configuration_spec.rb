require "spec_helper"

describe Eventify::Configuration do
  before do
    stub_const "Eventify::Configuration::PATH", File.join(Dir.tmpdir, "eventify-config.yml")
    File.delete Eventify::Configuration::PATH if File.exists? Eventify::Configuration::PATH
  end

  context "#initialize" do
    it "has default settings by default" do
      configuration = Eventify::Configuration.new
      expect(configuration[:subscribers]).to eq(["user@example.org"])
      expect(configuration[:mail]).to eq(Mail.delivery_method.settings.merge(openssl_verify_mode: "none"))
    end

    it "allows to override settings" do
      File.open(Eventify::Configuration::PATH, "w") { |f| f.write YAML.dump(foo: "baz") }

      configuration = Eventify::Configuration.new(foo: "bar")
      expect(configuration[:foo]).to eq("bar")
      expect(configuration[:subscribers]).to eq(["user@example.org"])
    end

    it "loads settings from file too" do
      File.open(Eventify::Configuration::PATH, "w") { |f| f.write YAML.dump(bar: "foo") }

      configuration = Eventify::Configuration.new(foo: "bar")
      expect(configuration[:foo]).to eq("bar")
      expect(configuration[:bar]).to eq("foo")
      expect(configuration[:subscribers]).to eq(["user@example.org"])
    end
  end

  context "#save" do
    it "saves config as yaml" do
      Eventify::Configuration.new(foo: "bar").save
      expect(YAML.load(File.read(Eventify::Configuration::PATH))[:foo]).to eq("bar")
    end

    it "saves subscribers as an array even if it is specified as a string" do
      Eventify::Configuration.new(subscribers: "foo@bar.com").save
      expect(YAML.load(File.read(Eventify::Configuration::PATH))[:subscribers]).to eq(["foo@bar.com"])
    end
  end

  context "#[]" do
    it "retrieves configuration setting" do
      expect(Eventify::Configuration.new(baz: "bar")[:baz]).to eq("bar")
    end
  end
end
