class Player

  def initialize

  end

  def display_mainui

  end

  def game_input
    puts "Enter two coordinates, and action separated by commas (x,y,f/r/u), or 'quit'."
    input = gets.chomp
    if input == 'quit'
      input = ['quit',nil,nil]
    else
      input = input.split(",")
    end
    input
  end
end