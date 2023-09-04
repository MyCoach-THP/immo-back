class AddPrivateToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :private, :boolean, default: false
  end
end
