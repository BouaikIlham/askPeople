class AddColorToInboxes < ActiveRecord::Migration[7.0]
  def change
    add_column :inboxes, :color, :string
  end
end
