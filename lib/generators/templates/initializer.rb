Ethikdo.configure do |config|
  config.api_key = ENV["ETHIKDO_API_KEY"]
  config.environment = Rails.env.production? ? :production : :development
end
