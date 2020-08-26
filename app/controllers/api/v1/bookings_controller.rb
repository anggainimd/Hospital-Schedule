class Api::V1::BookingsController < ApplicationController
  before_action :authenticate_api_v1_user!
  
  def index
    bookings = current_api_v1_user.bookings.map do |booking|
      {
        id: booking.id,
        book_no: booking.book_no,
        book_date: booking.book_date.to_date,
        day: Date::DAYNAMES[booking.schedule.day],
        schedule_time: "#{booking.schedule.start_time} - #{booking.schedule.end_time}",
        doctor: booking.schedule.doctor.attributes.slice('id', 'name'),
        hospital: booking.schedule.doctor.hospital.attributes.slice('id', 'name', 'address')
      } if booking.schedule_id
    end

    render json: {
      total: bookings.count,
      results: bookings
    }.to_json, status: :ok
  end

  def create
    @booking = current_api_v1_user.bookings.new(booking_params)
    if @booking.save
      render json: {results: @booking}
    else
      @error = @booking.errors.full_messages.uniq.join(', ')
      render json: { errors: @error }, status: 406
    end
  end

  def booking_params
    params.required(:booking).permit(:schedule_id, :book_date)
  end

end
