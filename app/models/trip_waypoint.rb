class TripWaypoint < ApplicationRecord
  belongs_to :place
  belongs_to :trip
end
