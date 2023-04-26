module Types
  class MutationType < Types::BaseObject
    field :create_toy, mutation: Mutations::CreateToy
    field :destroy_toy, mutation: Mutations::DestroyToy
  end
end
