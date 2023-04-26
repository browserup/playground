# frozen_string_literal: true

module Rpc
  class FunToyRequestEnumerator
    def initialize(fun_toys, delay = 0.5)
      @fun_toys = fun_toys
      @delay = delay.to_f
    end

    def each_item
      return enum_for(:each_item) unless block_given?
      @fun_toys.each do |fun_toy|
        sleep @delay
        puts "Next fun_toy to send is #{fun_toy.inspect}"
        yield fun_toy
      end
    end
  end
end
