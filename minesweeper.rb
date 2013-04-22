
require 'yaml.rb'

class Game

  def initialize
    @player = Player.new # create new player object, run main ui
    #@oldgame = yaml::load('./save.yaml') # assumes this works
    #@scores = yaml::load('./scores.yaml')
  end

  def game_loop
    while true
      puts "New Game/Load Game/Scores/Quit"
      input = gets.chomp
      case input
      when 'quit' then break
      when 'scores' then load_scores
      when 'load' then load_game
      when 'new' then new_game(5, 5)
      else
        puts 'Not valid input'
      end
    end
  end

  def load_scores

  end

  def load_game

  end

  def new_game(size, bombs)
    @board = Board.new(size, bombs)
    @board.display

    until lose? || win?
      input = @player.game_input # 3, 6, r/f => [[x, y], :action]
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

end # end Game class


class Tile
  attr_accessor :num, :bomb, :coords
  attr_reader :revealed

  @@converter = {
    :bomb => "[*]",
    :flag => "[!]",
    :revealed_empty => "[-]",
    :blank => "[ ]"
  }

  def initialize(bomb, coords)
    @bomb = bomb
    @revealed = false
    @flag = false
    @num = nil
    @coords = coords
  end

  def render
    if @revealed
      if @bomb
        @@converter[:bomb]
      elsif @num
        "[#{@num}]"
      else
        @@converter[:revealed_empty]
      end
    else
      if @flag
        @@converter[:flag]
      else
        @@converter[:blank]
      end
    end
  end

  def reveal
    @revealed = true unless @flag
  end

  def flag
    @flag = true
  end

  def unflag
    @flag = false
  end
end # end Tile class

class Board
  # fix bombs_by_row
  attr_reader :board

  def initialize(size, bombs = 10)
    @size = size
    @bombs = bombs
    set_board
    set_tile_num
  end

  def set_board

    @board = Array.new(@size) { Array.new(@size) { nil } }
    bombs_counter = 0
    dist = distribution



    @board.each_index do |i|
      @board[i].each_index do |j|
        @board[i][j] = Tile.new(dist[i][j],[i,j])
      end
    end
  end

  def distribution
    total_array = bombs_by_row
    res = Array.new(@size) { Array.new(@size) { nil } }

    res.each_index do |i|
      row = bombs_in_row(total_array[i])
      row.each_index do |j|
        res[i][j] = row[j]
      end
    end

    res
  end

  def bombs_by_row # not giving right number of bombs
    #refactor this later
    counter = 0
    dist = []

    @size.times do |row|
      if !(counter >= @bombs)
        bombs = rand((@bombs/2) + 2)
        if bombs + counter > @bombs
          bombs = @bombs - counter
        end
        counter += bombs
        dist << bombs
      else
        dist << @bombs - counter
      end
    end
    dist.shuffle
  end

  def bombs_in_row(total)
    counter = 0
    dist = Array.new(@size) {false}
    for i in 0...total
      dist[i] = true
    end
    dist.shuffle
  end

  def update(input)
    x = input[0].to_i
    y = input[1].to_i
    action = input[2]
    if action == 'r'
      @board[x][y].reveal
    elsif action == 'f'
      @board[x][y].flag
    elsif action == 'u'
      @board[x][y].unflag
    end

    reveal_fringe(board[x][y])
  end

  def reveal_fringe(tile)
    fringe = [tile]
    checked = []
    until fringe.empty?
      test = fringe.shift
      checked << test
      if test.num
        test.reveal
      elsif !test.bomb
        test.reveal
        children = spawn(test.coords[0], test.coords[1])
        children.each do |pair|
          fringe << @board[pair[0]][pair[1]] unless checked.include?(@board[pair[0]][pair[1]])
        end
      end
    end
  end

  def spawn(x, y)

    edges = [
      [x + 1, y],
      [x - 1, y],
      [x + 1, y + 1],
      [x + 1, y - 1],
      [x - 1, y + 1],
      [x - 1, y - 1],
      [x, y + 1],
      [x, y -1]
    ]
    res = edges.select { |edge| edge if (edge[0].between?(0,@size-1) && edge[1].between?(0,@size-1)) }
    res
  end

  def display
    @board.each do |row|
      row.each do |tile|
        print tile.render + " "
      end
      puts
    end
    nil
  end

  def num_tile(x, y)
    edges = [
      [x + 1, y],
      [x - 1, y],
      [x + 1, y + 1],
      [x + 1, y - 1],
      [x - 1, y + 1],
      [x - 1, y - 1],
      [x, y + 1],
      [x, y -1]
    ]

    edges.select! { |edge| edge[0].between?(0,@size-1) && edge[1].between?(0,@size-1) }
    bombs_count = 0
    edges.each do |edge|
      if @board[edge[0]][edge[1]].bomb
        bombs_count += 1
      end
    end

    bombs_count
  end

  def set_tile_num
    @board.each_with_index do |row, x|
      row.each_with_index do |tile, y|
        if num_tile(x,y) > 0
          tile.num = num_tile(x,y)
        end
      end
    end
  end

  def reveal_all
    @board.each do |row|
      row.each do |tile|
        tile.reveal
      end
    end
  end

  def check_win
    revealed = 0
    @board.each do |row|
      row.each do |tile|
        revealed += 1 if tile.revealed
      end
    end

    unless check_lose
      true if @size**2 - @bombs == revealed
    else
      false
    end
  end

  def check_lose
    lose = false
    @board.each do |row|
      row.each do |tile|
        lose = true if tile.bomb == true && tile.revealed == true
      end
    end
    lose
  end

end #end Board class

class Player

  def initialize

  end

  def display_mainui

  end

  def game_input
    puts "Enter two coordinates, and action separated by commas (x,y,f/r/u)"
    input = gets.chomp
    input = input.split(",")
    input
  end
end