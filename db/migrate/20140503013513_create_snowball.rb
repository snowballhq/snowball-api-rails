class CreateSnowball < ActiveRecord::Migration
  enable_extension 'uuid-ossp'

  def change
    create_table :users, id: :uuid do |t|
    end
  end
end
