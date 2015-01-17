require 'date'

class DSHelpers

  def self.get_dates_before_date(ammount, date)

    # create array with dates for simluations
    dates_array = Array.new
    current_date = date
    for i in 0..(ammount - 1)

      if (current_date.strftime("%m").eql? "08")
        current_date -= 100
      end

      current_date = current_date - 7
      dates_array.push(current_date)
    end

    return dates_array
  end

  def self.normalize_value(value, max_value, range = 1.0)

    return  ((value >= max_value ? max_value : value) / max_value.to_f) * range
  end

  def self.reverse_normalize_value(value, max_value, range = 1.0)
    return 0 if value >= max_value
    return normalize_value(max_value - value, max_value, range)
  end

end