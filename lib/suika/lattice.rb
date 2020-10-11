# frozen_string_literal: true

module Suika
  # @!visibility private
  class Lattice
    # @!visibility private
    attr_reader :begin_nodes, :end_nodes, :length

    # @!visibility private
    def initialize(length)
      @length = length
      @begin_nodes = Array.new(length + 1) { [] }
      @end_nodes = Array.new(length + 1) { [] }
      bos = Node.new(surface: 'BOS', unknown: false, left_id: 0, right_id: 0, cost: 0, attrs: [])
      @end_nodes[0].push(bos)
      eos = Node.new(surface: 'EOS', unknown: false, left_id: 0, right_id: 0, cost: 0, attrs: [])
      @begin_nodes[length].push(eos)
    end

    # @!visibility private
    def insert(begin_id, end_id, surface, unknown, left_id, right_id, cost, attrs)
      node = Node.new(surface: surface, unknown: unknown, left_id: left_id, right_id: right_id, cost: cost, attrs: attrs)
      @begin_nodes[begin_id].push(node)
      @end_nodes[end_id].push(node)
    end
  end
end
