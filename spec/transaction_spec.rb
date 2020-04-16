describe Ethikdo::Transaction do
  describe '.all' do
    before do
      stub_request(:get, /sales/).to_return(read_http_fixture('transactions/get_transactions_success.http'))
    end

    it 'builds the correct request' do
      Ethikdo::Transaction.all

      expect(WebMock).to have_requested(
        :get,
        'https://www.ethikdo.co/api/v1/sales/'
      )
    end

    it 'returns the correct response' do
      transactions = Ethikdo::Transaction.all

      expect(transactions).to be_a(Ethikdo::Transaction)
      expect(transactions.count).to eq(3)
      expect(transactions.results[0]['card_number']).to eq('1234123412341234')
    end
  end

  describe '.create' do
    before do
      Ethikdo::configuration.api_key = '1234'
      stub_request(:post, /sales/).to_return(read_http_fixture('transactions/create_success.http'))
    end

    it 'builds the correct request' do
      Ethikdo::Transaction.create(capture_token: 'foo', amount_requested: 10000, amount_purchased: 10000, transaction_id: 1)

      expect(WebMock).to have_requested(
        :post,
        'https://www.ethikdo.co/api/v1/sales/'
      ).with(headers: {
        'Accept' => 'application/json',
        'Authorization' => '1234',
        }, body: {
          'capture_token' => 'foo',
          'amount_requested' => '10000',
          'amount_purchased' => '10000',
          'transaction_id' => '1'
      })
    end

    it 'returns the correct response' do
      transaction = Ethikdo::Transaction.create(capture_token: 'foo', amount_requested: 10000, amount_purchased: 10000, transaction_id: 1)

      expect(transaction).to be_a(Ethikdo::Transaction)
      expect(transaction.transaction_id).to eq('1')
      expect(transaction.amount_purchased).to eq(1000)
    end
  end

  describe '.cancel' do
    before do
      Ethikdo::configuration.api_key = '1234'
      stub_request(:get, /sales/).to_return(read_http_fixture('transactions/cancel_success.http'))
    end

    it 'builds the correct request' do
      Ethikdo::Transaction.cancel(transaction_id: 1)

      expect(WebMock).to have_requested(
        :get,
        'https://www.ethikdo.co/api/v1/sales/1/cancel'
      ).with(headers: {
        'Accept' => 'application/json',
        'Authorization' => '1234',
        })
    end

    it 'returns the correct response' do
      transaction = Ethikdo::Transaction.cancel(transaction_id: 1)

      expect(transaction).to be_a(Ethikdo::Transaction)
      expect(transaction.message).to eq('La vente a bien été annulée et la carte a été recréditée de 10,00&nbsp;€.')
      expect(transaction.refund_amount).to eq(1000)
    end
  end
end
