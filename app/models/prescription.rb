class Prescription < ActiveRecord::Base
  belongs_to :drug
  belongs_to :doctor
  belongs_to :pharmacy
  belongs_to :user
  has_many :scheduled_doses

  validates :dose_size, :refills, :fill_duration, :start_date, presence: true
  validates :refills, :fill_duration, numericality: true

  scope :active, -> { where('end_date >= ? AND start_date <= ?', Date.today, Date.today) }
  scope :inactive, -> { where('end_date < ?', Date.today) }
  scope :ending_within_week, -> { where(end_date: Date.today..Date.today + 6).order(:end_date) }
  scope :time_of_day, -> (time_of_day) { joins(:scheduled_doses).where('time_of_day = ?', time_of_day).uniq }

  def doses_by_time_of_day(time_of_day)
    self.scheduled_doses.select {|dose| dose.time_of_day == time_of_day}.count
  end

  def refill
    if refills > 0
      self.refills -= 1
      self.end_date += self.fill_duration
      self.save
    end
  end

  def calculate_doses
    self.doses = self.fill_duration / self.doses_per_day
    self.save
  end

  def calculate_end_date
    self.end_date = self.start_date + self.fill_duration
    self.save
  end

  def format_date(date)
    date.strftime('%A, %B %d')
  end
end