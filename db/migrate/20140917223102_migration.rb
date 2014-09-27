class Migration < ActiveRecord::Migration
  def change
    rename_column :reels, :name, :title

    # the following changes are too complicated for change
    # so we use reversible
    reversible do |dir|
      dir.up do
        change_column_null :users, :name, true
        remove_column :users, :bio
        remove_column :clips, :zencoder_job_id
      end
      dir.down do
        change_column_null :users, :name, false
        add_column :users, :bio, :string
        add_column :clips, :zencoder_job_id
      end
    end
  end
end
