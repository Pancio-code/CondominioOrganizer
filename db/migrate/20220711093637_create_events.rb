class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :titolo
      t.datetime :start_time

      t.timestamps
    end
  end
end
