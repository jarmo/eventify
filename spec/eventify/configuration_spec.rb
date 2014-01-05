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
      configuration[:mail].should == Mail.delivery_method.settings
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
  end

  context "#[]" do
    it "retrieves configuration setting" do
      Eventify::Configuration.new(baz: "bar")[:baz].should == "bar"
    end
  end
end
