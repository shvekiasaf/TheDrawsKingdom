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

  def self.normalize_value(value, min_value, max_value, range = 100.0)
    return 100.0 if value >= max_value
    return 0.0 if value <= min_value

    zValue = ((value.to_f - min_value) / (max_value - min_value))
    return  zValue * range
  end

  def self.reverse_normalize_value(value,min_value, max_value, range = 100.0)

    return (range - normalize_value(value, min_value, max_value, range)).abs
  end

  def self.normalizeHashValues(hash, shouldReverseNormalization)

    sorted_values_array = hash.values.sort

    return nil if sorted_values_array.empty?

    minvalue = sorted_values_array[(sorted_values_array.size / 10).to_i]
    maxvalue = sorted_values_array[(sorted_values_array.size * 9 / 10).to_i]

    # print minvalue.to_s + " " + maxvalue.to_s + "\n"

    hash.each do |key, value|

      hash[key] = shouldReverseNormalization ?
          reverse_normalize_value(value, minvalue, maxvalue, 100.0) :
          normalize_value(value, minvalue, maxvalue, 100.0)
    end

    return hash
  end
end