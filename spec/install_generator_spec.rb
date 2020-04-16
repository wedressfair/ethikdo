describe Ethikdo::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../tmp', __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  after(:all) do
    FileUtils.rm_rf destination_root
  end

  it "creates correctly the initializer file" do
    assert_file "config/initializers/ethikdo.rb"
  end
end
