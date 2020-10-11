# frozen_string_literal: true

module Suika
  # @!visibility private
  class Node
    # @!visibility private
    attr_accessor :surface, :unknown, :min_cost, :min_prev, :left_id, :right_id, :cost, :attrs

    # @!visibility private
    def initialize(surface: '', unknown: false, min_cost: 0, min_prev: nil, left_id: 0, right_id: 0, cost: 0, attrs: [])
      @surface = surface
      @unknown = unknown
      @min_cost = min_cost
      @min_prev = min_prev
      @left_id = left_id
      @right_id = right_id
      @cost = cost
      @attrs = attrs
    end
  end
end
