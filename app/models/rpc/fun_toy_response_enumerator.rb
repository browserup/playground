# frozen_string_literal: true

module Rpc
  class FunToyResponseEnumerator
    def initialize(fun_toys, created_fun_toys, delay = 0.5)
      @fun_toys = fun_toys
      @created_fun_toys = created_fun_toys
      @delay = delay.to_f
    end

    def each_item
      Rails.logger.info "got to FunToyResponseEnumerator.each_item"
      return enum_for(:each_item) unless block_given?

      begin
        @fun_toys.each do |req|
          earlier_requests = @created_fun_toys[req.name]
          @created_fun_toys[req.name] << req
          Rails.logger.info "Got request: #{req.inspect}"

          earlier_requests.each do |r|
            fun_toy = FunToy.new(name: r.name, description: r.description).to_proto
            sleep @delay
            Rails.logger.info "Sending back to client: #{fun_toy.inspect}"
            yield fun_toy
          end
        end
      rescue StandardError => e
        fail e # signal completion via an error
      end
    end
  end
end
