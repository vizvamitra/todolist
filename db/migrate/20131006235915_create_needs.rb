class CreateNeeds < ActiveRecord::Migration
  def change
    create_table :needs do |t|
      t.text :text
      t.boolean :done, default:false

      t.timestamps
    end
  end
end
