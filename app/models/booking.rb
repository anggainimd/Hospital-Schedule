class Booking < ApplicationRecord
  belongs_to :schedule, optional: true
  belongs_to :user, optional: true
  
  validates :user_id, uniqueness: { scope: %i[schedule_id book_date], message: 'Already booking on this time' }
  validate :accept_booking
  before_save :set_no

  def set_no
    book_no = Booking.where(schedule_id: self.schedule_id, book_date: self.book_date ).count
    self.book_no = book_no + 1
  end

  def accept_booking
    book_no = Booking.where(schedule_id: self.schedule_id, book_date: self.book_date ).count
    return errors.add(:schedule, 'Booking full for this schedule') if book_no > 10

    available_schedule = self.schedule.doctor.monthly_schedule(self.book_date.to_date.month).map{|x| x[0]}
    return errors.add(:schedule, 'booking date not available') unless available_schedule.include?(self.book_date.to_date)

    close_time = "#{self.book_date} #{self.schedule.start_time}".to_datetime
    return errors.add(:schedule, 'booking registration closed, book early 30 minute before') unless Time.now <= close_time - 30.minutes
  end

end
