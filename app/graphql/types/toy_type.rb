class Types::ToyType < Types::BaseObject
  field :id, ID, null: false
  field :name, String, null: false
  field :description, String, null: false
end
