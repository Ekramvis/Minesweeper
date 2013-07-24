class Board
  attr_reader :board, :time

  def initialize(size, bombs = 10)
    @size = size
    @bombs = bombs
    set_board
    set_tile_num
    @start_time = Time.now.to_i
    @time = @start_time
  end

  def time_stamp
    @time = Time.now.to_i - @start_time
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

    if input[2].nil?
      action = 'r'
    else
      action = input[2]
    end

    if action == 'r'
      @board[x][y].reveal
      reveal_fringe(board[x][y])
    elsif action == 'f'
      @board[x][y].flag
    elsif action == 'u'
      @board[x][y].unflag
    end
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
    time_stamp
    puts ""
    puts "Clock: #{@time} seconds"
    puts ""

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

end 