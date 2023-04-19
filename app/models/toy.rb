class Toy < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 1 }

  def as_json(options = {})
    super(options.merge({:except => [:created_at, :updated_at]}))
  end
end
