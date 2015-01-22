require 'csv'
require 'open-uri'
require 'yaml'
require 'json'

require_relative "../model/ds_game"
require_relative "../model/ds_team"

class DSFileReader

  attr_reader :games_array, :teamsHash, :url_file_name

  # Initialize
  def initialize(url_file_name, force_init = false)

    # set the didInitialize flag to false
    @didInitialize = false
    @teams_games_hash = {}
    @url_file_name = url_file_name
    @force_init = force_init
    # init data arrays
    initDataFromFiles()

    # set the didInitialize flag to true
    @didInitialize = true
  end

  # return all games for team (Sorted by date). nil as date will ignore the value and give all the games without limit
  def getAllGamesFor(team, fromDate, toDate)

    if (@didInitialize)

      currentGamesArray = Array.new()

      # Cache the games per team array
      if (not @teams_games_hash.key?(team))

        @all_games = @games_array
        @all_games.each do |current_game|

          if ((current_game.away_team.team_name == team.team_name) ||
              (current_game.home_team.team_name == team.team_name))
            currentGamesArray.push(current_game)
          end
        end

        @teams_games_hash[team] = currentGamesArray
      else

        currentGamesArray = @teams_games_hash[team]
      end

      # filter only games between dates
      filteredGamesArray = Array.new()

      currentGamesArray.each do |current_game|

          if ((toDate.nil?) && (fromDate.nil?))
            filteredGamesArray.push(current_game)
          elsif (toDate.nil?)

            if (current_game.game_date > fromDate)
              filteredGamesArray.push(current_game)
            end

          elsif (fromDate.nil?)
            if (current_game.game_date < toDate)
              filteredGamesArray.push(current_game)
            end
          else
            if ((current_game.game_date < toDate) && (current_game.game_date > fromDate))
              filteredGamesArray.push(current_game)
            end
          end
      end

      return filteredGamesArray
    end
  end

  def getNextGameForTeam(team, fromDate)
    next_game_array = getSomeGamesForTeam(team, fromDate, 1)
    return nil if next_game_array.empty?
    next_game_array[0]
  end

  def getSomeGamesForTeam(team, fromDate, numberOfGames)

    currentGamesArray = Array.new()

    someGames = getAllGamesFor(team, fromDate, nil)

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

    relative_path = File.dirname(File.realpath(__FILE__)) + "/../../"
    all_games_url = relative_path + "DB/" + @url_file_name + "_games.drk"
    all_teams_url = relative_path + "DB/" + @url_file_name + "_teams.drk"

    if (!@force_init && File.exist?(all_games_url) && File.exist?(all_teams_url))

      print "Reading all data from disk.. \n"

      # Real all games from file
      @games_array = YAML.load(File.read(all_games_url))
      @teamsHash = YAML.load(File.read(all_teams_url ))
    else

      @teamsHash = {}
      @teams_names_dictionary = {}
      @games_array = Array.new()

      File.open(relative_path + "stats/" + @url_file_name).read.each_line do |current_file|

        # Creating teams dictionary
        if (current_file.start_with?("#"))

          splitter = current_file.split("#")
          @teams_names_dictionary[splitter[1]] = splitter[2]

        else
          print "Reading file: " + current_file + "\n"

          # Read from scores API
          if (current_file.include? "365scores.com")

            result = JSON.load(open(current_file).read)

            json_games = result["Games"]
            json_games.each() do |current_json_game|

              scrs = current_json_game["Scrs"]
              if (scrs[0] == -1.0)

                comps = current_json_game["Comps"]
                home_team = teamByName(comps[0]["Name"])
                away_team = teamByName(comps[1]["Name"])

                addTeamToHash(home_team)
                addTeamToHash(away_team)

                game_date = DateTime.strptime(current_json_game["STime"], '%d-%m-%Y %H:%M')

                if ((not home_team.nil?) && (not away_team.nil?))

                  # create game object
                  current_game = DSGame.new(game_date, @teamsHash[home_team], @teamsHash[away_team], -1, -1, nil, "NS", 0)

                  # insert game object to array
                  @games_array.push(current_game)
                end
              end
            end

            # Read from football-stats.co.uk CSVs
          else
            csv_data = open(current_file.strip)
            CSV.parse(csv_data.read, headers: true) do |row|

              season = current_file.split("/")[4]

              home_team = teamByName(row["HomeTeam"])
              away_team = teamByName(row["AwayTeam"])

              # add away team object to hash if needed
              addTeamToHash(away_team)

              # add home team object to hash if needed
              addTeamToHash(home_team)

              # add game object to games array
              if ((not home_team.nil?) && (not away_team.nil?))

                # create game object
                current_game = DSGame.new(DateTime.strptime(row["Date"], '%d/%m/%y'),
                                          @teamsHash[home_team], @teamsHash[away_team],
                                          row["FTHG"], row["FTAG"], row["Div"], season, row["B365D"])

                # insert game object to array
                @games_array.push(current_game)
              end
            end
          end
        end
      end

      # sort all games by date
      @games_array = @games_array.sort {|x,y| y.game_date <=> x.game_date}

      # Write data in files
      File.open(all_games_url, 'w') {|f| f.write(YAML.dump(@games_array)) }
      File.open(all_teams_url, 'w') {|f| f.write(YAML.dump(@teamsHash)) }
    end
  end


end

def addTeamToHash(team_title)

  if (not team_title.nil?)
    if (not @teamsHash.key?(team_title))
      @teamsHash[team_title] = DSTeam.new(team_title)
    end
  end
end

def teamByName(team_title)

  translated_team_title = team_title

  if (@teams_names_dictionary.key?(team_title))
    translated_team_title = @teams_names_dictionary[team_title]
  end

  return translated_team_title
end



