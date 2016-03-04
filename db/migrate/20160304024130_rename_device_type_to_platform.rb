class RenameDeviceTypeToPlatform < ActiveRecord::Migration
  def change
    rename_column :devices, :type, :platform
  end
end
