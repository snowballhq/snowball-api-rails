class RemovePhoneVerification < ActiveRecord::Migration
  def change
    remove_column :users, :phone_number_verification_code, :string
    remove_index :users, :phone_number
  end
end
