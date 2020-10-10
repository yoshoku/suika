# frozen_string_literal: true

require 'dartsclone'
require 'rubygems/package'
require 'zlib'

module Suika
  # Tagger is a class that tokenizes Japanese text.
  #
  # @example
  #   require 'suika'
  #
  #   tagger = Suika::Tagger.new
  #   tagger.parse('すもももももももものうち').each { |token| puts token }
  #
  #   # すもも  名詞,一般,*,*,*,*,すもも,スモモ,スモモ
  #   # も      助詞,係助詞,*,*,*,*,も,モ,モ
  #   # もも    名詞,一般,*,*,*,*,もも,モモ,モモ
  #   # も      助詞,係助詞,*,*,*,*,も,モ,モ
  #   # もも    名詞,一般,*,*,*,*,もも,モモ,モモ
  #   # の      助詞,連体化,*,*,*,*,の,ノ,ノ
  #   # うち    名詞,非自立,副詞可能,*,*,*,うち,ウチ,ウチ
  #
  class Tagger
    # Create a new tagger by loading the built-in binary dictionary.
    def initialize
      load_dictionary
    end

    # Parse the given sentence.
    # @param sentence [String] Japanese text to be parsed.
    # @return [Array<String>]
    def parse(sentence)
      lattice = Lattice.new(sentence.length)
      start = 0
      terminal = sentence.length

      while start < terminal
        step = terminal - start

        query = sentence[start..-1]
        result = @trie.common_prefix_search(query)
        unless result.empty?
          words, values = result
          words.each_with_index do |word, i|
            @dictionary[values[i]].each do |el|
              lattice.insert(start, start + word.length, word, false,
                             el[0].to_i, el[1].to_i, el[2].to_i, el[3..-1])
            end
          end
          step = words.map(&:size).min
        end

        word = sentence[start]
        char_cate = CharDef.char_category(sentence[start])
        char_type = CharDef.char_type(sentence[start])
        if char_cate[:invoke]
          char_length = char_cate[:group] ? CharDef::MAX_GROUPING_SIZE : char_cate[:length]
          unk_terminal = [start + char_length, terminal].min
          pos = start + 1
          while pos < unk_terminal && char_type == CharDef.char_type(sentence[pos])
            word << sentence[pos]
            pos += 1
          end
        end
        @unknown_dictionary[char_type].each do |el|
          lattice.insert(start, start + word.length, word, true,
                         el[0].to_i, el[1].to_i, el[2].to_i, el[3..-1])
        end
        step = [step, word.length].min

        start += step
      end

      viterbi(lattice)
    end

    private

    DICTIONARY_PATH = "#{__dir__}/../../dict/sysdic.gz"
    DICTIONARY_KEY = '562e53853b8a5b9f4857536b0748847a0878ebf0'
    INT_MAX = 2**(([42].pack('i').size * 16) - 2) - 1

    private_constant :DICTIONARY_PATH, :DICTIONARY_KEY, :INT_MAX

    def load_dictionary
      raise IOError, 'SHA1 digest of dictionary file does not match.' unless DICTIONARY_KEY == Digest::SHA1.file(DICTIONARY_PATH).to_s

      sysdic = Marshal.load(Zlib::GzipReader.open(DICTIONARY_PATH, &:read))
      @dictionary = sysdic[:dictionary]
      @unknown_dictionary = sysdic[:unknown_dictionary]
      @cost_mat = sysdic[:cost_matrix]
      @trie = DartsClone::DoubleArray.new
      @trie.set_array(sysdic[:trie])
    end

    def viterbi(lattice)
      bos = lattice.end_nodes[0].first
      bos.min_cost = 0
      bos.min_prev = nil

      (lattice.length + 1).times do |n|
        lattice.begin_nodes[n].each do |rnode|
          rnode.min_cost = INT_MAX
          rnode.min_prev = nil
          lattice.end_nodes[n].each do |lnode|
            cost = lnode.min_cost + @cost_mat[lnode.right_id][rnode.left_id] + rnode.cost
            if cost < rnode.min_cost
              rnode.min_cost = cost
              rnode.min_prev = lnode
            end
          end
        end
      end

      eos = lattice.begin_nodes[-1].first
      prev_node = eos.min_prev
      res = []
      until prev_node.nil?
        res.append("#{prev_node.surface}\t#{prev_node.attrs.join(',')}") if prev_node.surface != 'BOS' && prev_node.surface != 'EOS'
        prev_node = prev_node.min_prev
      end

      res.reverse
    end
  end
end
