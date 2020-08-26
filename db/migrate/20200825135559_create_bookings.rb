class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.integer :schedule_id
      t.integer :user_id
      t.integer :book_no
      t.datetime :book_date

      t.timestamps
    end
  end
end
