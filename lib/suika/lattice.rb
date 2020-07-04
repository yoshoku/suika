# frozen_string_literal: true

module Suika
  # @!visibility private
  class Lattice
    # @!visibility private
    Node = Struct.new(:surface, :min_cost, :min_prev, :left_id, :right_id, :cost, :attrs, keyword_init: true)

    attr_reader :begin_nodes, :end_nodes, :length

    # @!visibility private
    def initialize(length)
      @length = length
      @begin_nodes = Array.new(length + 1) { [] }
      @end_nodes = Array.new(length + 1) { [] }
      bos = Node.new(surface: 'BOS', left_id: 0, right_id: 0, cost: 0, attrs: [])
      @end_nodes[0].append(bos)
      eos = Node.new(surface: 'EOS', left_id: 0, right_id: 0, cost: 0, attrs: [])
      @begin_nodes[length].append(eos)
    end

    # @!visibility private
    def insert(begin_id, end_id, surface, left_id, right_id, cost, attrs)
      node = Node.new(surface: surface, left_id: left_id, right_id: right_id, cost: cost, attrs: attrs)
      @begin_nodes[begin_id].append(node)
      @end_nodes[end_id].append(node)
    end
  end
end
