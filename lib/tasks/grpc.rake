# frozen_string_literal: true

require 'faker'

namespace :test do
  task :get_toy, %i[hostname id] => :environment do |_, args|
    client = test_grpc_build_client(args, id: 1)

    begin
      toy = client.call(:GetToy, id: args[:id].to_i)
      puts toy.message.inspect
    rescue Gruf::Client::Error => e
      puts e.error.inspect
    end
  end

  task :get_toys, %i[hostname search limit] => :environment do |_, args|
    client = test_grpc_build_client(args, search: '', limit: 10)

    begin
      client_args = {
        limit: args[:limit].to_i
      }
      client_args[:search] = args[:search] if args[:search].to_s.present?
      toy = client.call(:GetToys, client_args)
      toy.message.each do |p|
        puts p.inspect
      end
    rescue Gruf::Client::Error => e
      puts e.error.inspect
    end
  end

  task :create_toys, %i[hostname number] => :environment do |_, args|
    client = test_grpc_build_client(args, number: 10)

    begin
      toys = []
      args[:number].to_i.times do
        toys << Rpc::Toy.new(
          name: Faker::Lorem.word,
          description: 'Red numbered toy' + rand(99999999).to_s
        )
      end
      toy = client.call(:CreateToys, toys)
      puts toy.message.inspect
    rescue Gruf::Client::Error => e
      puts e.error.inspect
    end
  end

  task :create_toys_in_stream, %i[hostname number delay] => :environment do |_, args|
    client = test_grpc_build_client(args, number: 10, delay: 0.5)

    begin
      toys = []
      args[:number].to_i.times do
        toys << Rpc::Toy.new(
          name: Faker::Lorem.word,
          description: 'Red numbered toy' + rand(99999999).to_s
        )
      end
      enumerator = Rpc::ToyRequestEnumerator.new(toys, args[:delay].to_f)
      client.call(:CreateToysInStream, enumerator.each_item) do |r|
        puts "Received response: #{r.inspect}"
      end

    rescue Gruf::Client::Error => e
      puts e.error.inspect
    end
  end

  ##
  # @param [Rake::TaskArguments] args
  # @param [Hash] defaults
  # @return [Gruf::Client]
  #
  def test_grpc_build_client(args, defaults = {})
    args.with_defaults(
      defaults.merge(
        hostname: "#{::ENV.fetch('GRPC_SERVER_HOST', '127.0.0.1')}:#{::ENV.fetch('GRPC_SERVER_PORT', 409090)}",
        password: ::ENV.fetch('GRPC_AUTH_TOKEN', 'austin').to_s.strip
      )
    )
    ::Gruf::Client.new(
      service: ::Rpc::Toys,
      options: {
        hostname: args[:hostname],
        username: 'test',
        password: args[:password],
        client_options: {
          timeout: ENV.fetch('GRPC_TIMEOUT', 10)
        }
      }
    )
  end
end
