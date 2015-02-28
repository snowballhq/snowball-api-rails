class AddMissingPaperclipAttributes < ActiveRecord::Migration
  def change
    add_column :users, :avatar_file_size, :string
    add_column :users, :avatar_updated_at, :string
    add_column :clips, :video_file_size, :string
    add_column :clips, :video_updated_at, :string
    add_column :clips, :thumbnail_file_size, :string
    add_column :clips, :thumbnail_updated_at, :string
  end
end
