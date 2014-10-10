class AddPhoneNumberConfirmation < ActiveRecord::Migration
  def change
    add_column :users, :phone_number_verification_code, :string
    add_column :users, :phone_number_verified, :boolean, null: false, default: false
  end
end
