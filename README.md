# Suika

[![Build Status](https://github.com/yoshoku/suika/workflows/build/badge.svg)](https://github.com/yoshoku/suika/actions?query=workflow%3Abuild)
[![Gem Version](https://badge.fury.io/rb/suika.svg)](https://badge.fury.io/rb/suika)
[![BSD 3-Clause License](https://img.shields.io/badge/License-BSD%203--Clause-orange.svg)](https://github.com/yoshoku/suika/blob/main/LICENSE.txt)
[![Documentation](https://img.shields.io/badge/api-reference-blue.svg)](https://rubydoc.info/gems/suika)

Suika 🍉 is a Japanese morphological analyzer written in pure Ruby.

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

# すもも  名詞,一般,*,*,*,*,すもも,スモモ,スモモ
# も      助詞,係助詞,*,*,*,*,も,モ,モ
# もも    名詞,一般,*,*,*,*,もも,モモ,モモ
# も      助詞,係助詞,*,*,*,*,も,モ,モ
# もも    名詞,一般,*,*,*,*,もも,モモ,モモ
# の      助詞,連体化,*,*,*,*,の,ノ,ノ
# うち    名詞,非自立,副詞可能,*,*,*,うち,ウチ,ウチ
```

Since the Tagger class loads the binary dictionary at initialization, it is recommended to reuse the instance.

```ruby
tagger = Suika::Tagger.new

sentences.each do |sentence|
  result = tagger.parse(sentence)

  # ...
end
```

## Test
Suika was able to parse all sentences in the [Livedoor news corpus](https://www.rondhuit.com/download.html#ldcc)
without any error.

```ruby
require 'suika'

tagger = Suika::Tagger.new

Dir.glob('ldcc-20140209/text/*/*.txt').each do |filename|
  File.foreach(filename) do |sentence|
    sentence.strip!
    puts tagger.parse(sentence) unless sentence.empty?
  end
end
```

![suika_test](https://user-images.githubusercontent.com/5562409/90264778-8f593f80-de8c-11ea-81f1-20831e3c8b12.gif)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshoku/suika.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [BSD-3-Clause License](https://opensource.org/licenses/BSD-3-Clause).
In addition, the gem includes binary data generated from mecab-ipadic.
The details of the license can be found in [LICENSE.txt](https://github.com/yoshoku/suika/blob/main/LICENSE.txt)
and [NOTICE.txt](https://github.com/yoshoku/suika/blob/main/NOTICE.txt).

## Respect

- [Taku Kudo](https://github.com/taku910) is the author of [MeCab](https://taku910.github.io/mecab/) that is the most famous morphological analyzer in Japan.
MeCab is one of the great software in natural language processing.
Suika is created with reference to [the book on morphological analysis](https://www.kindaikagaku.co.jp/information/kd0577.htm) written by Dr. Kudo.
- [Tomoko Uchida](https://github.com/mocobeta) is the author of [Janome](https://github.com/mocobeta/janome) that is a Japanese morphological analysis engine written in pure Python.
Suika is heavily influenced by Janome's idea to include the built-in dictionary and language model.
Janome, a morphological analyzer written in scripting language, gives me the courage to develop Suika.
