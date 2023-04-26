# frozen_string_literal: true

##
# Represents a fun_toy service that is used for illustrating server calls
#
class FunToysController < Gruf::Controllers::Base
  bind ::Rpc::FunToys::Service

  def initialize(args)
    @received_fun_toys = Hash.new { |h, k| h[k] = [] }
    super(**args)
  end

  ##
  # Illustrates a request and response call
  #
  # @return [Rpc::GetFunToyResp] The response
  #
  def get_fun_toy
    fun_toy = Toy.find(request.message.id.to_i)

    Rpc::GetFunToyResp.new(
      fun_toy: Rpc::FunToy.new(
        id: fun_toy.id.to_i,
        name: fun_toy.name.to_s,
        description: fun_toy.description.to_s
      )
    )
  rescue ActiveRecord::RecordNotFound => _e
    fail!(:not_found, :fun_toy_not_found, "Failed to find FunToy with ID: #{request.message.id}")
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  ##
  # Illustrates a server streaming call
  #
  # @return [Rpc::FunToy] An enumerable of FunToys that is streamed
  #
  def get_fun_toys
    return enum_for(:get_fun_toys) unless block_given?

    q = Toy
    q = q.where('name LIKE ?', "%#{request.message.search}%") if request.message.search.present?
    limit = request.message.limit.to_i.positive? ? request.message.limit : 100
    q.limit(limit).each do |fun_toy|
      sleep(rand(0.01..0.3))
      yield fun_toy.to_proto
    end
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  ##
  # Illustrates a client streaming call
  #
  # @return [Rpc::CreateFunToysResp]
  #
  def create_fun_toys
    fun_toys = []
    request.messages do |message|
      fun_toys << Toy.new(name: message.name, description: message.description).to_proto
    end
    Rpc::CreateFunToysResp.new(fun_toys: fun_toys)
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  ##
  # @return [Enumerable<Rpc::FunToy>]
  #
  def create_fun_toys_in_stream
    return enum_for(:create_fun_toys_in_stream) unless block_given?

    request.messages.each do |r|
      sleep(rand(0.01..0.3))
      yield Toy.new(name: r.name, description: r.description).to_proto
    rescue StandardError => e
      set_debug_info(e.message, e.backtrace[0..4])
      fail!(:internal, :internal, "ERROR: #{e.message}")
    end
  end
end
