require 'yaml.rb'
require_relative 'tile.rb'
require_relative 'board.rb'
require_relative 'player.rb'


class Game

  def initialize
    @player = Player.new
    if File.exists?('score')
      @top_score = YAML::load( File.read('score') )
    else
      @top_score = nil
    end
    game_loop
  end

  def game_loop
    while true
      puts ""
      puts "New Game | Load Game | Save Game | Scores | Quit"
      input = gets.chomp
      case input
      when 'quit' then break
      when 'scores' then load_scores
      when 'save' then save_game
      when 'load' then load_game
      when 'new' then new_game(5, 2)
      else
        puts 'Not valid input'
      end
    end
    puts ""
    puts "Goodbye!"
  end

  def load_scores
    puts "Top score is #{@top_score}"
  end

  def save_game
    File.open("save", "w") do |f|
      f.puts @board.to_yaml
    end
  end

  def load_game
    if File.exists?('save')
      @board = YAML::load( File.read('save') )
      old_game
    end
  end

  def new_game(size, bombs)
    @board = Board.new(size, bombs)
    @board.display

    until lose? || win?
      input = @player.game_input # 3, 6, r/f => [[x, y], :action]
      if input[0] == "quit"
        return puts "You have exited the game."
      end
      @board.update(input)
      @board.display
      puts ""
    end
    puts win? ? "You won!" : "You lose!"

    if @top_score.nil? && win?
      File.open("score", "w") do |f|
        f.puts @board.time.to_yaml
      end
    elsif !@top_score.nil?
      if (@board.time < @top_score) && win?
        File.open("score", "w") do |f|
          f.puts @board.time.to_yaml
        end
      end
    end

    @board.reveal_all
    @board.display
  end

  def old_game
    @board.display

    until lose? || win?
      input = @player.game_input # 3, 6, r/f => [[x, y], :action]
      if input[0] == "quit"
        return puts "You have exited the game."
      end
      @board.update(input)
      @board.display
    end
    puts win? ? "You won!" : "You lose!"
    @board.reveal_all
    @board.display
  end

  def win?
    @board.check_win
  end

  def lose?
    @board.check_lose
  end

end 


Game.new