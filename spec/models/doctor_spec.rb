require 'rails_helper'

RSpec.describe Doctor, type: :model do
  describe "Relations" do
    it "should belongs to hospital" do
      t = Doctor.reflect_on_association(:hospital)
      expect(t.macro).to eq(:belongs_to)
    end

    it "should has many schedule" do
      t = Doctor.reflect_on_association(:schedules)
      expect(t.macro).to eq(:has_many)
    end
  end

  describe "Available Schedule" do
    before(:each) do
      hospital = Hospital.create(
        name: 'RS Adven',
        address: 'Jalan Cihampelas No. 161, Kota Bandung, Jawa Barat'
      )
      doctor = Doctor.create(
        name: "Dr. #{Faker::Name.name}",
        hospital: hospital
      )
      monday = 1      
      doctor.schedules.create(day: monday, start_time: "10:00", end_time: "13:00")
    end

    it "should has many schedule" do
      practice_times = {}
      start_month = select_month = Date.new(Time.now.year, 1, 01)
      end_month = start_month.end_of_month
      Doctor.first.schedules.map{|s| practice_times[s.day] = "#{s.start_time} - #{s.end_time}"}
      expect(Doctor.first.monthly_schedule(1)).to eq((start_month..end_month).to_a.map {|k| [k, practice_times[k.wday]] if practice_times.keys.include?(k.wday) }.compact)
    end

  end
end
