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
tagger.parse('すもももももももものうち').each { |token| puts token }

# すもも  名詞, 一般, *, *, *, *, すもも, スモモ, スモモ
# も      助詞, 係助詞, *, *, *, *, も, モ, モ
# もも    名詞, 一般, *, *, *, *, もも, モモ, モモ
# も      助詞, 係助詞, *, *, *, *, も, モ, モ
# もも    名詞, 一般, *, *, *, *, もも, モモ, モモ
# の      助詞, 連体化, *, *, *, *, の, ノ, ノ
# うち    名詞, 非自立, 副詞可能, *, *, *, うち, ウチ, ウチ
```

Since the Tagger class loads the binary dictionary at initialization, it is recommended to reuse the instance.

```ruby
tagger = Suika::Tagger.new

sentences.each do |sentence|
  result = tagger.parse(sentence)

  # ...
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshoku/suika.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yoshoku/suika/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [BSD-3-Clause License](https://opensource.org/licenses/BSD-3-Clause).
In addition, the gem includes binary data generated from mecab-ipadic.
The details of the license can be found in LICENSE.txt and NOTICE.txt.

## Respect

- [Taku Kudo](https://github.com/taku910) is the author of [MeCab](https://taku910.github.io/mecab/) that is the most famous morphological analyzer in Japan.
MeCab is one of the great software in natural language processing.
Suika is created with reference to [the book on morphological analysis](https://www.kindaikagaku.co.jp/information/kd0577.htm) written by Dr. Kudo.
- [Tomoko Uchida](https://github.com/mocobeta) is the author of [Janome](https://github.com/mocobeta/janome) that is a Japanese morphological analysis engine written in pure Python.
Suika is heavily influenced by Janome's idea to include the built-in dictionary and language model.
Janome, a morphological analyzer written in scripting language, gives me the courage to develop Suika.

## Code of Conduct

Everyone interacting in the Suika project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yoshoku/suika/blob/master/CODE_OF_CONDUCT.md).
