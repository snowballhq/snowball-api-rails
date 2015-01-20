class CreateSnowball < ActiveRecord::Migration
  enable_extension 'uuid-ossp'

  def change
    create_table :users, id: :uuid do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :name
      t.string :email, null: false
      t.string :phone_number
      t.string :phone_number_verification_code
      t.string :auth_token, null: false
      t.timestamps null: false
    end
    add_index :users, :username, unique: true
    add_index :users, :phone_number, unique: true
    add_index :users, :auth_token, unique: true

    create_table :follows, id: :uuid do |t|
      t.uuid :following_id, null: false
      t.uuid :follower_id, null: false
      t.timestamps null: false
    end

    create_table :clips, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :video_file_name, null: false
      t.string :video_content_type, null: false
      t.string :thumbnail_file_name, null: false
      t.string :thumbnail_content_type, null: false
      t.timestamps null: false
    end

    create_table :flags, id: :uuid do |t|
      t.uuid :clip_id, null: false
      t.timestamps null: false
    end
  end
end
