class Migration < ActiveRecord::Migration
  def change
    # change reel name to title
    rename_column :reels, :name, :title

    # the following changes are too complicated for change
    # so we use reversible
    reversible do |dir|
      dir.up do
        # change users name to not required
        change_column_null :users, :name, true
        # remove bio
        remove_column :users, :bio
      end
      dir.down do
        change_column_null :users, :name, false
        add_column :users, :bio, :string
      end
    end
  end
end
