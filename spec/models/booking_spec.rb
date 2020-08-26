require 'rails_helper'

RSpec.describe Booking, type: :model do

  describe "Booking" do
    book_date = Time.now + 1.weeks
    second_book_date = Time.now + 1.weeks + 1.days

    let(:user) { User.create(
      email: Faker::Internet.email,
      password: "Pass123456",
      password_confirmation: "Pass123456"
    )}
    let(:hospital) { Hospital.create(
      name: 'RS Adven',
      address: 'Jalan Cihampelas No. 161, Kota Bandung, Jawa Barat'
    )}
    let(:doctor) { Doctor.create(
      name: Faker::Name.name,
      hospital: hospital
    )}
    let(:schedule) { Schedule.create(
      doctor: doctor,
      day: Time.now.wday,
      start_time: (Time.now + 1.hour).strftime("%H:%m"),
      end_time: (Time.now + 4.hour).strftime("%H:%m")
    )}
    let(:second_schedule) { Schedule.create(
      doctor: doctor,
      day: second_book_date.wday,
      start_time: (second_book_date + 1.hour).strftime("%H:%m"),
      end_time: (second_book_date + 4.hour).strftime("%H:%m")
    )}
    let(:booking) {
      Booking.create(
        user: user,
        schedule: schedule,
        book_date: book_date
      )
    }
    let(:second_booking) {
      Booking.create(
        user: user,
        schedule: schedule,
        book_date: book_date
      )
    }
    let(:third_booking) {
      Booking.create(
        user: user,
        schedule: second_schedule,
        book_date: second_book_date
      )
    }
    let(:schedule_late) { Schedule.create(
      doctor: doctor,
      day: Time.now.wday,
      start_time: (Time.now + 30.minutes).strftime("%H:%m"),
      end_time: (Time.now + 4.hour).strftime("%H:%m")
    )}
    let(:booking_late) {
      Booking.create(
        user_id: user.id,
        schedule_id: schedule_late.id,
        book_date: Time.now
      )
    }

    before(:each) do
      date_book = (Time.now + 2.days).to_date.to_s
      hospital = Hospital.create(
        name: 'RS Adven2',
        address: 'Jalan Cihampelas No. 161, Kota Bandung, Jawa Barat2'
      )
      doctor = Doctor.create(
        name: "Dr. #{Faker::Name.name}",
        hospital: hospital
      )
      day_plus = Time.now.wday + 2
      schedule = doctor.schedules.create(day: day_plus, start_time: "10:00", end_time: "13:00")
      (1..11).each do |i|
        Booking.create(
          user_id: i+100,
          schedule: schedule,
          book_date: date_book
        )
      end
    end

    it "create a booking without error" do
      expect(booking.errors).to be_empty
    end

    it "create a booking with error registration closed" do
      expect(booking_late.errors.full_messages.uniq.join(', ')).to eq('Schedule booking registration closed, book early 30 minute before')
    end

    before { booking }
    it "create a booking with error double booking" do  
      expect(second_booking.errors.full_messages.uniq.join(', ')).to eq('User Already booking on this time')
    end

    it "create a booking with error Schedule booking date not available" do
      expect(third_booking.errors.full_messages.uniq.join(', ')).to eq('Schedule booking date not available')
    end

    it "create a booking without error" do
      schedule = Schedule.where(day: Time.now.wday + 2).first
      expect(user.bookings.create(schedule: schedule, book_date: (Time.now + 2.days).to_date.to_s).errors.full_messages.uniq.join(', ')).to eq('Schedule Booking full for this schedule')
    end
  end
end
