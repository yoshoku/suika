# frozen_string_literal: true

require 'rambling-trie'
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
      ipadic = Marshal.load(Zlib::GzipReader.open(__dir__ + '/../../dict/ipadic.gz', &:read))
      @trie = ipadic[:trie]
      @dictionary = ipadic[:dictionary]
      @unknown_dictionary = ipadic[:unknown_dictionary]
      @cost_mat = ipadic[:cost_matrix]
    end

    # Parse the given sentence.
    # @param sentence [String] Japanese text to be parsed.
    # @return [Array<String>]
    def parse(sentence)
      lattice = Lattice.new(sentence.length)
      start = 0
      terminal = sentence.length

      while start < terminal
        word = sentence[start]
        pos = start
        matched = false
        while @trie.match?(word) && pos < terminal
          if @dictionary.key?(word)
            matched = true
            @dictionary[word].each do |el|
              lattice.insert(start, start + word.length, word, false,
                             el[0].to_i, el[1].to_i, el[2].to_i, el[3..-1])
            end
          end
          pos += 1
          word = sentence[start..pos]
        end

        word = sentence[start]
        char_cate = CharDef.char_category(sentence[start])
        unless !char_cate[:invoke] && matched
          char_length = char_cate[:group] ? CharDef::MAX_GROUPING_SIZE : char_cate[:length]
          unk_terminal = [start + char_length, terminal].min
          pos = start + 1
          char_type = CharDef.char_type(sentence[start])
          while pos < unk_terminal && char_type == CharDef.char_type(sentence[pos])
            word << sentence[pos]
            pos += 1
          end
          @unknown_dictionary[char_type].each do |el|
            lattice.insert(start, start + word.length, word, true,
                           el[0].to_i, el[1].to_i, el[2].to_i, el[3..-1])
          end
        end

        start += 1
      end

      viterbi(lattice)
    end

    private

    INT_MAX = 2**(([42].pack('i').size * 16) - 2) - 1

    private_constant :INT_MAX

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
