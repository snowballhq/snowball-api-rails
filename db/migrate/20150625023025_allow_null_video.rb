class AllowNullVideo < ActiveRecord::Migration
  def change
    change_column_null :clips, :video_file_name, true
    change_column_null :clips, :video_content_type, true
    change_column_null :clips, :thumbnail_file_name, true
    change_column_null :clips, :thumbnail_content_type, true
  end
end
