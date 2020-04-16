describe Ethikdo::BaseModel do
  describe '.execute' do
    it 'sends the request with the correct headers' do
      stub_request(:get, /test/)
      Ethikdo::configuration.api_key = '1234'

      Ethikdo::BaseModel.execute('get', '/test/')

      expect(WebMock).to have_requested(
        :get,
        'https://www.ethikdo.co/api/v1/test/'
      ).with(headers: {
        'Accept' => 'application/json',
        'Authorization' => '1234'
      })
    end

    it 'raises a custom error when no api key is submitted' do
      stub_request(:get, /test/).to_return(read_http_fixture('forbidden/no_token.http'))

      expect do
        Ethikdo::BaseModel.execute('get', '/test/')
      end.to raise_error(Ethikdo::ResponseError)
    end

    it 'raises a custom when a wrong api key is submitted' do
      stub_request(:get, /test/).to_return(read_http_fixture('forbidden/wrong_token.http'))

      expect do
        Ethikdo::BaseModel.execute('get', '/test/')
      end.to raise_error(Ethikdo::ResponseError)
    end
  end
end
