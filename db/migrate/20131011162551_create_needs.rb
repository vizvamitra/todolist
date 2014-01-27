class CreateNeeds < ActiveRecord::Migration
  def change
    create_table :needs do |t|
      t.text :text
      t.boolean :completed, default: false
      t.integer :user_id

      t.timestamps
    end
  end
end
