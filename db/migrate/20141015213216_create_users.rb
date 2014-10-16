class CreateUsers < ActiveRecord::Migration
  enable_extension 'uuid-ossp'

  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :phone_number, null: false
      t.string :phone_number_verification_code
      t.string :auth_token, null: false
      t.timestamps null: false
    end
    add_index :users, :phone_number, unique: true
    add_index :users, :auth_token, unique: true
  end
end
