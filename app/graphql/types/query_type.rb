module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # queries are just represented as fields
    # `all_links` is automatically camelcased to `allLinks`
    field :new_toys, [ToyType], null: false

    def new_toys
      Toy.last(10)
    end

    field :toy_by_name, Types::ToyType, null: true do
      argument :name, String, required: true
    end

    def toy_by_name(name:)
      Toy.find_by(name: name)
    rescue ActiveRecord::RecordNotFound => e
      GraphQL::ExecutionError.new("Record Not Found with name: #{name}")
    end

    field :toy_by_id, Types::ToyType, null: true do
      argument :id, String, required: true
    end
    def toy_by_id(id:)
      Toy.find(id)
    rescue ActiveRecord::RecordNotFound => e
      GraphQL::ExecutionError.new("Record Not Found with ID: #{id}")
    end


  end
end
