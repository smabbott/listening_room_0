class CreateVoices < ActiveRecord::Migration
  def change
    create_table :voices do |t|
      t.float :am
      t.float :fm
      t.float :carrier
      t.integer :tempo 
      t.timestamps
    end
    drop_table :ips
  end
end
