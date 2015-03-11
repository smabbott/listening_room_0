class AddIpToVoice < ActiveRecord::Migration
  def change
    add_column :voices, :address, :string
  end
end
