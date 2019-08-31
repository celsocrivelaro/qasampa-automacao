require 'date'

class AgeCalculator
  def self.calculate(date)
    ((Date.today - Date.parse(date))/365).to_i
  end
end