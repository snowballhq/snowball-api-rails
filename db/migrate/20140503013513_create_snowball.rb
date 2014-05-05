class CreateSnowball < ActiveRecord::Migration
  enable_extension 'uuid-ossp'

  def change
    create_table :reels, id: :uuid do |t|
      t.timestamps
    end
  end
end
