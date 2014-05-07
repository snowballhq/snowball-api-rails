class CreateSnowball < ActiveRecord::Migration
  enable_extension 'uuid-ossp'

  def change
    create_table :reels, id: :uuid do |t|
      t.timestamps
    end
    create_table :clips, id: :uuid do |t|
      t.belongs_to :reel
      t.string :video_file_name
      t.timestamps
    end
  end
end
