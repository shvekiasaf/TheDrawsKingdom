require_relative "components/ds_file_reader"
require 'date'
require 'csv'
require 'fileutils'
require 'linefit'
module DrawHistogramGenerator
  should_init_data_store = false

  file_readers = [
      DSFileReader.new('german_urls', should_init_data_store ),
      DSFileReader.new('spanish_urls', should_init_data_store ),
      DSFileReader.new('italian_urls', should_init_data_store ),
      DSFileReader.new('greece_urls', should_init_data_store ),
      DSFileReader.new('belgium_urls', should_init_data_store ),
      DSFileReader.new('frances_urls', should_init_data_store ),
      DSFileReader.new('nethderland_urls', should_init_data_store ),
      DSFileReader.new('portugali_urls', should_init_data_store ),
      DSFileReader.new('turkey_urls', should_init_data_store ),
  # DSFileReader.new("english_urls",should_init_data_store )
  ]

  def self.calculateSuccessHistogram(games)
    gamesWith365Score = games.select { |current_game| (not current_game.b365_draw_odds.nil?) and current_game.b365_draw_odds.to_f > 0}
    histogram = gamesWith365Score.map { |x| [x.b365_draw_odds, 0] }.to_h
    success_histogram = histogram.clone
    gamesWith365Score.each do |game|
      histogram[game.b365_draw_odds] = 1 + histogram[game.b365_draw_odds]
      if game.isDraw
        success_histogram[game.b365_draw_odds] = 1 + success_histogram[game.b365_draw_odds]
      end
    end

    histogram = histogram.sort_by{|k,v| k.to_f}.to_h
    success_histogram = success_histogram.sort_by{|k,v| k.to_f}.to_h

    return histogram.map { |k, v| [k.to_s, ('%.2f' % (success_histogram[k].to_f / v.to_f)).to_s, v]}
  end

  all_games = file_readers.map { |fr| fr.games_array }.flatten
  histogram = calculateSuccessHistogram(all_games)

  def self.print_csv(histogram, file_name)
    CSV.open("../365Success/" + file_name, "w") do |csv|
      # enter titles
      csv << ['ratio', 'success', 'number of games']
      histogram.each { |entry| csv << entry }
    end
  end

  print_csv(histogram, 'total_games.csv')
  file_readers.each do |fr|
    local_histogram = calculateSuccessHistogram(fr.games_array)
    print_csv(local_histogram, '365_success_' + fr.url_file_name)
  end


end

