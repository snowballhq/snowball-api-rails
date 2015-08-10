class FixPaperclip < ActiveRecord::Migration
  def change
    remove_column :users, :avatar_updated_at, :string
    remove_column :clips, :video_updated_at, :string
    remove_column :clips, :thumbnail_updated_at, :string

    add_column :users, :avatar_updated_at, :datetime
    add_column :clips, :video_updated_at, :datetime
    add_column :clips, :thumbnail_updated_at, :datetime
  end
end
