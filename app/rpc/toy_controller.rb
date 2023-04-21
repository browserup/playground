# note this is a Gruf controller, not a Rails controller and it is singular

class ToyController < Gruf::Controllers::Base
  bind ::Rpc::Toy::Service

  def initialize(args)
    @received_toys = Hash.new { |h, k| h[k] = [] }
    super(**args)
  end

  ##
  # Illustrates a request and response call
  #
  # @return [Rpc::GetToyResp] The response
  #
  def get_toy
    toy = ::Toy.find(request.message.id.to_i)

    Rpc::GetToyResp.new(
      toy: Rpc::Toy.new(
        id: toy.id.to_i,
        name: toy.name.to_s,
        description: toy.description.to_s
      )
    )
  rescue ActiveRecord::RecordNotFound => _e
    fail!(:not_found, :toy_not_found, "Failed to find Toy with ID: #{request.message.id}")
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  ##
  # Illustrates a server streaming call
  #
  # @return [Rpc::Toy] An enumerable of Toys that is streamed
  #
  def get_toys
    return enum_for(:get_toys) unless block_given?
    q = ::Toy
    q = q.where('name LIKE ?', "%#{request.message.search}%") if request.message.search.present?
    limit = request.message.limit.to_i.positive? ? request.message.limit : 100
    q.limit(limit).each do |toy|
      sleep(rand(0.01..0.3))
      yield toy.to_proto
    end
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  ##
  # Illustrates a client streaming call
  #
  # @return [Rpc::CreateToysResp]
  #
  def create_toys
    toys = []
    request.messages do |message|
      toys << Toy.new(name: message.name, description: message.description).to_proto
    end
    Rpc::CreateToysResp.new(toys: toys)
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  ##
  # @return [Enumerable<Rpc::Toy>]
  #
  def create_toys_in_stream
    return enum_for(:create_toys_in_stream) unless block_given?

    request.messages.each do |r|
      sleep(rand(0.01..0.3))
      yield Toy.new(name: r.name, description: r.description).to_proto
    rescue StandardError => e
      set_debug_info(e.message, e.backtrace[0..4])
      fail!(:internal, :internal, "ERROR: #{e.message}")
    end
  end
end
