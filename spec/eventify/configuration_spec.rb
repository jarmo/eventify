require "spec_helper"

describe Eventify::Configuration do
  before do
    stub_const "Eventify::Configuration::PATH", File.join(Dir.tmpdir, "eventify-config.yml")
    File.delete Eventify::Configuration::PATH if File.exists? Eventify::Configuration::PATH
  end

  context "#initialize" do
    it "has default settings by default" do
      configuration = Eventify::Configuration.new
      configuration[:subscribers].should == ["user@example.org"]
      configuration[:mail].should == Mail.delivery_method.settings.merge(openssl_verify_mode: "none")
    end

    it "allows to override settings" do
      File.open(Eventify::Configuration::PATH, "w") { |f| f.write YAML.dump(foo: "baz") }

      configuration = Eventify::Configuration.new(foo: "bar")
      configuration[:foo].should == "bar"
      configuration[:subscribers].should == ["user@example.org"]
    end

    it "loads settings from file too" do
      File.open(Eventify::Configuration::PATH, "w") { |f| f.write YAML.dump(bar: "foo") }

      configuration = Eventify::Configuration.new(foo: "bar")
      configuration[:foo].should == "bar"
      configuration[:bar].should == "foo"
      configuration[:subscribers].should == ["user@example.org"]
    end
  end

  context "#save" do
    it "saves config as yaml" do
      Eventify::Configuration.new(foo: "bar").save
      YAML.load(File.read(Eventify::Configuration::PATH))[:foo].should == "bar"
    end

    it "saves subscribers as an array even if it is specified as a string" do
      Eventify::Configuration.new(subscribers: "foo@bar.com").save
      YAML.load(File.read(Eventify::Configuration::PATH))[:subscribers].should == ["foo@bar.com"]
    end
  end

  context "#[]" do
    it "retrieves configuration setting" do
      Eventify::Configuration.new(baz: "bar")[:baz].should == "bar"
    end
  end
end
