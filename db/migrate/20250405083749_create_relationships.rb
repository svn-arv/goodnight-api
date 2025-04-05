class CreateRelationships < ActiveRecord::Migration[7.2]
  def change
    create_table :relationships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :following, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :relationships, %i[user_id following_id], unique: true
  end
end
