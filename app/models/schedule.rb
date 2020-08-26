class Schedule < ApplicationRecord
  belongs_to :doctor, optional: true
  has_many :bookings
end
