# Suika

Suika is a Japanese morphological analyzer written in pure Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'suika'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install suika

## Usage

```ruby
require 'suika'

tagger = Suika::Tagger.new
tagger.parse('すもももももももものうち').each do |token|
  puts token
end

# すもも  名詞, 一般, *, *, *, *, すもも, スモモ, スモモ
# も      助詞, 係助詞, *, *, *, *, も, モ, モ
# もも    名詞, 一般, *, *, *, *, もも, モモ, モモ
# も      助詞, 係助詞, *, *, *, *, も, モ, モ
# もも    名詞, 一般, *, *, *, *, もも, モモ, モモ
# の      助詞, 連体化, *, *, *, *, の, ノ, ノ
# うち    名詞, 非自立, 副詞可能, *, *, *, うち, ウチ, ウチ
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshoku/suika.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yoshoku/suika/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [BSD-3-Clause License](https://opensource.org/licenses/BSD-3-Clause).

## Code of Conduct

Everyone interacting in the Suika project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yoshoku/suika/blob/master/CODE_OF_CONDUCT.md).
