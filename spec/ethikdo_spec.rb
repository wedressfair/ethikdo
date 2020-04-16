describe Ethikdo do
  after(:all) do
    Ethikdo.reset_configuration
  end

  it "has a version number" do
    expect(Ethikdo::VERSION).not_to be nil
  end

  describe Ethikdo::Configuration do
    it 'has a configurable api key' do
      Ethikdo.configuration.api_key = "42"
      expect(Ethikdo.configuration.api_key).to eq("42")
    end

    it 'accepts only 2 values for its instance variable "environment": "production" and "development"' do
      Ethikdo.configuration.environment = :development
      expect(Ethikdo.configuration.environment).to eq(:development)

      Ethikdo.configuration.environment = :foo
      expect(Ethikdo.configuration.environment).to eq(nil)

      Ethikdo.configuration.environment = :production
      expect(Ethikdo.configuration.environment).to eq(:production)
    end

    it 'has different base url for the development and production environment' do
      Ethikdo.configuration.environment = :development
      expect(Ethikdo::BaseModel.base_url).to eq(Ethikdo::BaseModel::BASE_TEST_URL)

      Ethikdo.configuration.environment = :production
      expect(Ethikdo::BaseModel.base_url).to eq(Ethikdo::BaseModel::BASE_URL)
    end
  end
end
