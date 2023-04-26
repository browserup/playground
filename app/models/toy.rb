class Toy < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 1 }

  def as_json(options = {})
    super(options.merge({:except => [:created_at, :updated_at]}))
  end

  # To keep the RPC classes separate, they are named FunToy
  def to_proto
    Rpc::FunToy.new(
      id: id.to_i,
      name: name.to_s,
      description: description.to_s
    )
  end
end
