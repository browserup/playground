module Mutations
  class CreateToy < BaseMutation
    # arguments passed to the `resolve` method
    argument :name, String, required: true
    argument :description, String, required: true

    # return type from the mutation
    type Types::ToyType

    def resolve(name: nil, description: nil )
      Toy.create!(
        description: description,
        name: name,
        )
      { name: name, description: description}
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
