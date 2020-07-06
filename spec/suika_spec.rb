# frozen_string_literal: true

RSpec.describe Suika do
  it 'performs morphological analysis' do
    tagger = Suika::Tagger.new
    result = tagger.parse('すもももももももものうち')
    expect(result).to eq([
      "すもも\t名詞, 一般, *, *, *, *, すもも, スモモ, スモモ",
      "も\t助詞, 係助詞, *, *, *, *, も, モ, モ",
      "もも\t名詞, 一般, *, *, *, *, もも, モモ, モモ",
      "も\t助詞, 係助詞, *, *, *, *, も, モ, モ",
      "もも\t名詞, 一般, *, *, *, *, もも, モモ, モモ",
      "の\t助詞, 連体化, *, *, *, *, の, ノ, ノ",
      "うち\t名詞, 非自立, 副詞可能, *, *, *, うち, ウチ, ウチ"
    ])
    result = tagger.parse('ヴィンランドサガの新刊を買う')
    expect(result).to eq([
      "ヴィンランドサガ\t名詞, 一般, *, *, *, *, *",
      "の\t助詞, 連体化, *, *, *, *, の, ノ, ノ",
      "新刊\t名詞, 一般, *, *, *, *, 新刊, シンカン, シンカン",
      "を\t助詞, 格助詞, 一般, *, *, *, を, ヲ, ヲ",
      "買う\t動詞, 自立, *, *, 五段・ワ行促音便, 基本形, 買う, カウ, カウ"
    ])
  end
end
