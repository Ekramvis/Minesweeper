class Tile
  attr_accessor :num, :bomb

  @@converter = {
    :bomb => "[*]",
    :flag => "[!]",
    :revealed_empty => "[-]",
    :blank => "[ ]"
  }

  def initialize(bomb)
    @bomb = bomb
    @revealed = false
    @flag = false
    @num = nil
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
    @revealed = true
  end

  def flag
    @flag = true
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
        @board[i][j] = Tile.new(dist[i][j])
      end
    end
  end

  def distribution
    total_array = bombs_by_row
    puts "Bombs by row: #{total_array}"
    res = Array.new(@size) { Array.new(@size) { nil } }

    res.each_index do |i|
      row = bombs_in_row(total_array[i])
      puts "Total array[#{i}]:  #{total_array[i]} "
      row.each_index do |j|
        res[i][j] = row[j]
      end
      puts "Row: #{row}"
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

  end

  def display
    @board.each do |row|
      row.each do |tile|
        print tile.render + " "
      end
      puts
    end
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
        puts "x is #{x}"
        puts "y is #{y}"
        tile.num = num_tile(x,y)
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

end #end Board class