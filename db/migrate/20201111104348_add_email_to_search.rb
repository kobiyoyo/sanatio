class AddEmailToSearch < ActiveRecord::Migration[6.0]
  def change
    add_column :searches, :email, :string
  end
end
