class CreateToys < ActiveRecord::Migration[7.0]
  def change
    create_table :toys do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
    add_index :toys, :name, unique: true
  end
end
