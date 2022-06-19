# frozen_string_literal: true

RSpec.describe Suika do
  let(:tagger) { Suika::Tagger.new }

  it 'does not display instance variables on inspect method' do
    expect(tagger.inspect).not_to include('@sysdic')
  end

  it 'performs morphological analysis', :aggregate_failures do
    result = tagger.parse('すもももももももものうち')
    expect(result).to eq(
      [
        "すもも\t名詞,一般,*,*,*,*,すもも,スモモ,スモモ",
        "も\t助詞,係助詞,*,*,*,*,も,モ,モ",
        "もも\t名詞,一般,*,*,*,*,もも,モモ,モモ",
        "も\t助詞,係助詞,*,*,*,*,も,モ,モ",
        "もも\t名詞,一般,*,*,*,*,もも,モモ,モモ",
        "の\t助詞,連体化,*,*,*,*,の,ノ,ノ",
        "うち\t名詞,非自立,副詞可能,*,*,*,うち,ウチ,ウチ"
      ]
    )
    result = tagger.parse('高輪ゲートウェイ駅は港区にあります')
    expect(result).to eq(
      [
        "高輪\t名詞,固有名詞,地域,一般,*,*,高輪,タカナワ,タカナワ",
        "ゲートウェイ\t名詞,固有名詞,地域,一般,*,*,*",
        "駅\t名詞,接尾,地域,*,*,*,駅,エキ,エキ",
        "は\t助詞,係助詞,*,*,*,*,は,ハ,ワ",
        "港\t名詞,固有名詞,地域,一般,*,*,港,ミナト,ミナト",
        "区\t名詞,接尾,地域,*,*,*,区,ク,ク",
        "に\t助詞,格助詞,一般,*,*,*,に,ニ,ニ",
        "あり\t動詞,自立,*,*,五段・ラ行,連用形,ある,アリ,アリ",
        "ます\t助動詞,*,*,*,特殊・マス,基本形,ます,マス,マス"
      ]
    )
    result = tagger.parse('ヴィンランドサガの新刊を買う')
    expect(result).to eq(
      [
        "ヴィンランドサガ\t名詞,一般,*,*,*,*,*",
        "の\t助詞,連体化,*,*,*,*,の,ノ,ノ",
        "新刊\t名詞,一般,*,*,*,*,新刊,シンカン,シンカン",
        "を\t助詞,格助詞,一般,*,*,*,を,ヲ,ヲ",
        "買う\t動詞,自立,*,*,五段・ワ行促音便,基本形,買う,カウ,カウ"
      ]
    )
    result = tagger.parse('㍻から㋿へ')
    expect(result).to eq(
      [
        "㍻\t名詞,サ変接続,*,*,*,*,*",
        "から\t助詞,格助詞,一般,*,*,*,から,カラ,カラ",
        "㋿\t名詞,サ変接続,*,*,*,*,*",
        "へ\t助詞,格助詞,一般,*,*,*,へ,ヘ,エ"
      ]
    )
  end
end
