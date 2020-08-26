class Api::V1::DoctorsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    doctors = Doctor.all.map do |doctor|
      {
        id: doctor.id,
        name: doctor.name,
        hospital: {
          name: doctor.hospital.name,
          address: doctor.hospital.address
        },
        schedules: [
          doctor.schedules.map do |schedule|
            {
              id: schedule.id,
              day: Date::DAYNAMES[schedule.day],
              "#{Time.now.strftime("%B")}": doctor.monthly_schedule(Time.now.month)
            }
          end
        ]
      }
    end

    render json: {
      total: doctors.count,
      results: doctors
    }.to_json, status: :ok
  end

  def schedules
    month = params[:month] ?  params[:month].to_i : Time.now.month
    month_name = params[:month] ? Date.new(Time.now.year, params[:month].to_i).strftime("%B") : Time.now.strftime("%B")

    doctors = Doctor.all.map do |doctor|
      {
        id: doctor.id,
        name: doctor.name,
        schedules: [
          doctor.schedules.map do |schedule|
            {
              id: schedule.id,
              day: Date::DAYNAMES[schedule.day],
              "#{month_name}": doctor.monthly_schedule(month)
            }
          end
        ]
      }
    end
    
    render json: {
        total: doctors.count,
        results: doctors
    }.to_json, status: :ok
  end
end
