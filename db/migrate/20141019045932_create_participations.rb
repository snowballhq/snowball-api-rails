class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :reel_id, null: false
      t.uuid :last_watched_clip_id
      t.timestamps null: false
    end
  end
end
