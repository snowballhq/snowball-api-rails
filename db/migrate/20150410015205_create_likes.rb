class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :clip_id, null: false
      t.timestamps null: false
    end
  end
end
