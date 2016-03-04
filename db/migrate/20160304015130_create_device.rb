class CreateDevice < ActiveRecord::Migration
  def change
    create_table :devices, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.boolean :development, null: false, default: false
      t.integer :type, null: false, default: 0
      t.string :token, null: false
      t.timestamps null: false
    end
  end
end
