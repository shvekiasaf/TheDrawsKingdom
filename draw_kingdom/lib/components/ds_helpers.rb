require 'date'

class DSHelpers

  def self.get_dates_before_date(ammount, date)

    # create array with dates for simluations
    dates_array = Array.new
    current_date = date - 60
    for i in 0..(ammount - 1)

      if (current_date.strftime("%m").eql? "08")
        current_date -= 100
      end

      current_date = current_date - 7
      dates_array.push(current_date)
    end

    return dates_array
  end
end