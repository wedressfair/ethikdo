# Ethikdo

This gem provides an easy way to manage transactions for Ethi'kdo card holders through the Ethi'kdo v1 REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ethikdo'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ethikdo

## Usage

__Configuration__

The gem needs to be configured with your private API key. To do so, execute:

```
rails generate ethikdo:install
```

This will generate a file named `ethikdo.rb` in `config/initializers/` with the following content:

```ruby
Ethikdo.configure do |config|
  config.api_key = ENV["ETHIKDO_API_KEY"]
  config.environment = Rails.env.production? ? :production : :development
end
```

Now, set up your private key as an environment variable in your `.env` file:

```
ETHIKDO_API_KEY = "Token XXXXXXX"
```

The gem can be configured for two environments: _production_ and _development_. By default, the gem's environment is set to _production_ if Rails is in _production_, else it is set to _development_.

In _development_, the requests are sent to a test API provided by Ethi'kdo. The test API's url is:
```
https://recette.ethikdo.co/api/v1/
```

In _production_, the requests are sent to the real API:
```
https://www.ethikdo.co/api/v1
```


__Capture a paiement__

The first step to capture a paiement is to obtain a capture token. This is done through the `Ethikdo::Provision` class and requires the card's number (16 digits) and card's secret key (3 digits):

```ruby
provision = Ethikdo::Provision.create(
    card_number: card_number,
    card_crypto: card_crypto
)
```
If the card's credentials are correct, an `Ethikdo::Provision` object is returned:

```ruby
# Ethikdo::Provision:0x0000555a80009698
 @capture_token = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
 @card_number = "1234123412341234",
 @card_value = 500000,
 @date_created = "2020-04-16T16:36:46.128007+02:00",
 @date_used = nil,
 @url = "https://recette.ethikdo.co/api/v1/provisions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/"
```

Once you have obtained the capture token, you can now use the `Ethikdo::Transaction` class to capture the paiement:

```ruby
transaction = Ethikdo::Transaction.create(
    capture_token: capture_token,
    amount_requested: order.total_price_cents,
    amount_purchased: order.total_price_cents,
    transaction_id: order.id,
    customer_email: nil
)
```

If the transaction succeeds, an `Ethikdo::Transaction` object is returned:

```ruby
# Ethikdo::Transaction:0x0000555a82216f38
 @amount_debited = 100000,
 @amount_purchased = 100000,
 @cancelled = false,
 @card_number = "1234123412341234",
 @date = "2020-04-16T15:25:56.451488Z",
 @transaction_id = "1",
 @url = "https://recette.ethikdo.co/api/v1/sales/1/" #/1 being the transaction id
```

__Cancel a transaction__

You can cancel a transaction through the `Ethikdo::Transaction` class:

```ruby
Ethikdo::Transaction.cancel(transaction_id: transaction_id)
```

If the cancellation is successful, an `Ethikdo::Transaction` object is returned with a success message and the amount refunded:

```ruby
# Ethikdo::Transaction:0x0000555a846ccb48
 @message = "La vente a bien été annulée et la carte a été recréditée de 1000,00€.",
 @refund_amount = 100000
```

__List the provisions and transactions associated to your API key__

List all the provisions:
```ruby
Ethikdo::Provision.all
```

Example of an `Ethikdo::Provision` object returned:

```ruby
# Ethikdo::Provision:0x0000555a82909390
 @count = 1,
 @next = nil,
 @previous = nil,
 @results =
    [
        {
            "url"=>"https://recette.ethikdo.co/api/v1/provisions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/",
            "capture_token"=>"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "card_number"=>"1234123412341234",
            "card_value"=>400000,
            "date_created"=>"2020-04-16T16:36:46.128007+02:00",
            "date_used"=>"2020-04-16T15:25:56.451488Z"
        }
    ]
```

Similarly, list all the transactions:

```ruby
Ethikdo::Transaction.all
```

Example of an `Ethikdo::Transaction` object returned:

```ruby
# Ethikdo::Transaction:0x0000555a835d68c0
 @count = 1,
 @next = nil,
 @previous = nil,
 @results =
    [
        {
            "url"=>"https://recette.ethikdo.co/api/v1/sales/1/",
            "transaction_id"=>"1",
            "customer_email"=>nil,
            "card_number"=>"1234123412341234",
            "amount_purchased"=>100000,
            "amount_debited"=>100000,
            "cancelled"=>false,
            "date"=>"2020-04-16T15:25:56.451488Z"
        }
    ]
```

__Errors__

If a request returns an error (invalid card number, amount requested greater than card value, invalid capture token, etc.), an `Ethikdo::Error` is raised. This can be simply handled by a `begin/rescue` block:

```ruby
begin
    Ethikdo::transaction.cancel(transaction_id: 1)
rescue Ethikdo::Error => e
    e.inspect
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Don't forget to add tests and run rspec before creating a pull request :)


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
