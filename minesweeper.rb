require 'yaml.rb'

class Game

  def intialize
    @player = Player.new # create new player object, run main ui
    @oldgame = yaml::load('./save.yaml') # assumes this works
    @scores = yaml::load('./scores.yaml')
  end

  def game_loop
    while true
      puts "New Game/Load Game/Scores/Quit"
      input = gets.chomp
      case input
      when 'quit' then break
      when 'scores' then load_scores
      when 'load' then load_game
      when 'new' then new_game
      else
        puts 'Not valid input'
      end
  end

  def load_scores

  end

  def load_game

  end

  def new_game
    @board = Board.new
    until win?
      input = @player.input

  end


end # end Game class

class Board

  def initialize(size, bombs = 10)
    @size = size
    @bombs = bombs
    set_board
  end

  def set_board
    @board = Array.new(size) {[]}
    bombs_counter = 0
    dist = bombs_by_row
    @board.each_index do |index|
      @board[index] = bombs_in_row(dist[index])
    end
  end

  def bombs_by_row
    #refactor this later
    counter = 0
    dist = []

    @size.times do |row|
      if !(counter >= @bombs)
        bombs = rand((@bombs/2) + 1)
        if bombs + counter > @bombs
          bombs = @bombs - counter
        end
        counter += bombs
        dist << bombs
      else
        dist << 0
      end
    end
    dist.shuffle
  end

  def bombs_in_row(total)
    counter = 0
    dist = Array.new(9) {false}
    for i in 0...total
      dist[i] = true
    end
    dist.shuffle
  end


end #end Board class



# board
# init(size, bombs = set)
#   2-d array of tile objects
#   #bombs
#   #time --> now
#
# tiles
# bomb / empty
# revealed / not revealved
# flagged / not flagged
#
# #timestamp
# timenow - init time
#
# #display
# current state





class Player < Game

  def initialize
    display_mainui
  end

  def display_mainui

  end
end

#
# game class
# stores: board, scores
#
# #play loop
#
# loop until win or bomb hit
# displays board state
# takes input from player
# updates board
# -----
# display final board
#
#
# Player class
# main ui
#   load
#   - load up board, runs game loop
#   run(new)
#   - create new board object(size), start game loop
#   scores
#   - stored within game file
#
# game ui
# #display board
# #take input
#
#
# ---------
# board
# init(size, bombs = set)
#   2-d array of tile objects
#   #bombs
#   #time --> now
#
# tiles
# bomb / empty
# revealed / not revealved
# flagged / not flagged
#
# #timestamp
# timenow - init time
#
# #display
# current state