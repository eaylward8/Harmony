class CreateScheduledDoses < ActiveRecord::Migration
  def change
    create_table :scheduled_doses do |t|
      t.string :time_of_day
      t.integer :prescription_id

      t.timestamps null: false
    end
  end
end
