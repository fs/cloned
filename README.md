# Cloned

Simple gem for copying trees of ActiveRecord models.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloned'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloned

## Usage

First you need to define clonning stategy:

```ruby
class CompanyCopyStrategy < Cloned::Strategy
  declare :company do
    before(copied_company) do
      copied_company.copied_at = Time.zone.now
    end

    nullify :created_at, :updated_at

    association(:departments)
  end

  declare :department do
    association(:employees)
  end

  declare :employee do
    nullify :last_sickleave, :vacation_at
  end
end
```
Then you able to build or create clones:

```ruby
CompanyCopyStrategy.make(Company.first, Account.last.companies)
```

or

```ruby
CompanyCopyStrategy.create(Company.first, Account.last.companies)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AskarZinurov/cloned.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
