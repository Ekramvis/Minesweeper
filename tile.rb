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
end
