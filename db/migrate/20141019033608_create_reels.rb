class CreateReels < ActiveRecord::Migration
  def change
    create_table :reels, id: :uuid do |t|
      t.string :title
      t.timestamps null: false
    end
  end
end
