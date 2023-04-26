module Mutations
  class DestroyToy < BaseMutation
    field :id, Integer, null: true

    argument :id, Integer, required: true
    # return type from the mutation
    type Types::ToyType

    def resolve(id: nil )
      toy = Toy.find(id)
      toy.destroy
      { id: id }
    rescue ActiveRecord::RecordNotFound => e
      GraphQL::ExecutionError.new("Record Not Found with ID: #{id}")
    end
  end
end
