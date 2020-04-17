module RSpecSupportHelpers

  def http_fixture(*names)
    File.join(SPEC_ROOT, 'http_fixtures', *names)
  end

  def read_http_fixture(*names)
    File.read(http_fixture(*names))
  end

end

RSpec.configure do |config|
  config.include RSpecSupportHelpers
end
