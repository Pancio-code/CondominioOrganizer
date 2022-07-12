class AddCalendarId < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :calendar_id, :string,null: true
  end
end
