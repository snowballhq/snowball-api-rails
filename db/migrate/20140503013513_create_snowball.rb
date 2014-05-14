class CreateSnowball < ActiveRecord::Migration
  enable_extension 'uuid-ossp'

  def change
    create_table :users, id: :uuid do |t|
      t.string :username, null: false
      t.string :auth_token, null: false
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :auth_token, unique: true
    add_index :users, :username, unique: true
    add_index :users, :reset_password_token, unique: true

    create_table :reels, id: :uuid do |t|
      t.string :name
      t.timestamps
    end

    create_table :clips, id: :uuid do |t|
      t.uuid :reel_id
      t.string :video_file_name
      t.integer :zencoder_job_id
      t.timestamps
    end
  end
end
