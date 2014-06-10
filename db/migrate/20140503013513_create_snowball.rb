class CreateSnowball < ActiveRecord::Migration
  enable_extension 'uuid-ossp'

  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :username, null: false
      t.string :bio
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

    create_table :identities, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :uid, null: false
      t.string :provider, null: false
      t.timestamps
    end

    create_table :reels, id: :uuid do |t|
      t.string :name
      t.timestamps
    end

    create_table :clips, id: :uuid do |t|
      t.uuid :reel_id, null: false
      t.uuid :user_id, null: false
      t.string :video_file_name, null: false
      t.integer :zencoder_job_id
      t.timestamps
    end

    create_table :likes, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :likeable_id, null: false
      t.string :likeable_type, null: false
      t.timestamps
    end

    create_table :notifications, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :notifiable_id, null: false
      t.string :notifiable_type, null: false
      t.timestamps
    end
  end
end
