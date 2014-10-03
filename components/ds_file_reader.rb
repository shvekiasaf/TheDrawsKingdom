require 'csv'
require 'open-uri'

require_relative "../model/ds_game"
require_relative "../model/ds_team"

class DSFileReader

  attr_reader :games_array, :teamsHash

  # Initialize
  def initialize(files_folder_path)

    # set the didInitialize flag to false
    @didInitialize = false

    @files_folder_path = files_folder_path

    # init data arrays
    initDataFromFiles()

    # set the didInitialize flag to true
    @didInitialize = true
  end

  # return all games for team (Sorted by date)
  def getAllGamesFor(team, fromDate, toDate)

    if (@didInitialize)
      currentGamesArray = Array.new()

      @all_games = @games_array

      @all_games.each do |current_game|

        if (((current_game.away_team == team) || (current_game.home_team == team)) &&
            ((current_game.game_date < toDate) && (current_game.game_date > fromDate)))
          currentGamesArray.push(current_game)
        end

      end

      return currentGamesArray
    end
  end

  def getSomeGamesForTeam(team, fromDate, numberOfGames)

    currentGamesArray = Array.new()

    someGames = getAllGamesFor(team, fromDate, Date.parse("31-12-2055"))

    someGames.reverse.each() do |current_game|

      if (numberOfGames > 0)
        currentGamesArray.push(current_game)
        numberOfGames -= 1
      end
    end

    return currentGamesArray.reverse
  end

  # return array of all games form file
  def initDataFromFiles

    @teamsHash = {}
    @games_array = Array.new()

    File.open(@files_folder_path).read.each_line do |current_file|

      print "Reading file: " + current_file + "\n"

      csv_data = open(current_file)
      CSV.parse(csv_data.read, headers: true) do |row|

        # add away team object to hash if needed
        @awayTitle = row["AwayTeam"]
        if (not @awayTitle.nil?)
          if (not @teamsHash.key?(@awayTitle))
            @teamsHash[@awayTitle] = DSTeam.new(@awayTitle)
          end
        end

        # add home team object to hash if needed
        @homeTitle = row["HomeTeam"]
        if (not @homeTitle.nil?)
          if (not @teamsHash.key?(@homeTitle))
            @teamsHash[@homeTitle] = DSTeam.new(@homeTitle)
          end
        end

        # add game object to games array
        if ((not @awayTitle.nil?) && (not @homeTitle.nil?))

          # create game object
          current_game = DSGame.new(row["Date"], @teamsHash[@homeTitle], @teamsHash[@awayTitle], row["FTHG"], row["FTAG"])

          # insert game object to array
          @games_array.push(current_game)
        end      end
    end

    # sort all games by date
    @games_array = @games_array.sort {|x,y| y.game_date <=> x.game_date}
  end
end

