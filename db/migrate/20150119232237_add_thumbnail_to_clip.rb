class AddThumbnailToClip < ActiveRecord::Migration
  def change
    add_column :clips, :thumbnail_file_name, :string
    add_column :clips, :thumbnail_content_type, :string
    change_column :clips, :thumbnail_file_name, :string, null: false
    change_column :clips, :thumbnail_content_type, :string, null: false
  end
end
