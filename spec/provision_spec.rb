describe Ethikdo::Provision do
  describe '.all' do
    before do
      stub_request(:get, /provisions/).to_return(read_http_fixture('provisions/get_provisions_success.http'))
    end

    it 'builds the correct request' do
      Ethikdo::Provision.all

      expect(WebMock).to have_requested(
        :get,
        'https://www.ethikdo.co/api/v1/provisions/'
      )
    end

    it 'returns the correct response' do
      provisions = Ethikdo::Provision.all

      expect(provisions).to be_a(Ethikdo::Provision)
      expect(provisions.count).to eq(2)
      expect(provisions.results[0]['card_number']).to eq('1234123412341234')
    end
  end

  describe '.create' do
    before do
      Ethikdo::configuration.api_key = '1234'
      stub_request(:post, /provisions/).to_return(read_http_fixture('provisions/create_success.http'))
    end

    it 'builds the correct request' do
      Ethikdo::Provision.create(card_number: 1234123412341234, card_crypto: 123)

      expect(WebMock).to have_requested(
        :post,
        'https://www.ethikdo.co/api/v1/provisions/'
      ).with(headers: {
        'Accept' => 'application/json',
        'Authorization' => '1234',
        }, body: {
          'card_number' => '1234123412341234',
          'card_crypto' => '123'
      })
    end

    it 'returns the correct response' do
      provision = Ethikdo::Provision.create(card_number: 1234123412341234, card_crypto: 123)

      expect(provision).to be_a(Ethikdo::Provision)
      expect(provision.card_number).to eq('1234123412341234')
      expect(provision.card_value).to eq(500000)
    end
  end
end
