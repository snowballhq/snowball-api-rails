class AddThumbnailToClip < ActiveRecord::Migration
  def change
    add_column :clips, :thumbnail_file_name, :string, null: false
    add_column :clips, :thumbnail_content_type, :string, null: false
  end
end
