class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.integer :doctor_id
      t.integer :day
      t.datetime :practice_date
      t.string :start_time
      t.string :end_time

      t.timestamps
    end
  end
end
