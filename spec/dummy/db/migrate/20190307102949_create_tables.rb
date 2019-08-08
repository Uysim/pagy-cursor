class CreateTables < ActiveRecord::Migration[5.0]
  def self.up
    create_table(:users) do |t|
      t.string :name
      t.timestamps
    end

    create_table(:posts, id: false) do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.string :title
      t.timestamps
    end

  end

  def self.down
    drop_table :users
    drop_table :posts
  end
end
