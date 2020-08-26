class Doctor < ApplicationRecord
  belongs_to :hospital, optional: true
  has_many :schedules

  def monthly_schedule(month)
    practice_times = {}
    year = Date.today.strftime("%Y").to_i
    start_month = select_month = Date.new(year, month, 01)
    end_month = start_month.end_of_month
    self.schedules.map{|s|
      practice_times[s.day] = "#{s.start_time} - #{s.end_time}"
    }
    result = (start_month..end_month).to_a.map {|k| [k, practice_times[k.wday]] if practice_times.keys.include?(k.wday) }.compact
    return result
  end
end
