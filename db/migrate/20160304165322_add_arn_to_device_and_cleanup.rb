class AddArnToDeviceAndCleanup < ActiveRecord::Migration
  def change
    add_column :devices, :arn, :string, null: false
    remove_column :devices, :development, :boolean, default: false, null: false
    remove_column :devices, :platform, :integer, default: 0, null: false
    remove_column :devices, :token, :string, null: false
  end
end
