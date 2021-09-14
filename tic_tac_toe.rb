# frozen_string_literal: true

# Player
class Player
  attr_reader :name, :token

  def initialize(name, token)
    @name = name
    @token = token
  end
end

# Grid
class Grid
  WIN = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
         [0, 3, 6], [1, 4, 7], [2, 5, 8],
         [0, 4, 8], [2, 4, 6]].freeze
  CHOICES = ['x', 'o'].freeze
  
  attr_reader :player

  def initialize
    @pos = (1..9).to_a
    @player = []
    create_grid
  end

  def get_players
    token = ''
    x = 1

    2.times do
      print "Player#{x}, Enter your name: "
      name = gets.chomp

      if token == ''
        until CHOICES.include?(token)
          print 'Choose x or o: '
          token = gets.chomp
        end
      else
        token == 'x' ? token = 'o' : token = 'x'
      end

      @player << Player.new(name, token)
      x += 1
    end
  end

  def update(player, position)
    @pos[position.to_i - 1] = player.token
    create_grid
  end

  def check_win?
    WIN.any? { |w| [@pos[w[0]], @pos[w[1]], @pos[w[2]]].uniq.size == 1 }
  end

  private

  def create_grid
    i = 0
    lines = {out: "    :   :    \n", mid: "----:---:----\n", pos: line_pos(i)}
    layout = [:out, :pos, :mid, :pos, :mid, :pos, :out]
    layout.each do |l|
      print lines[l]
      lines[:pos] = line_pos(i += 3) if l == :mid
    end
  end
 
  def line_pos(i)
    "  #{@pos[i]} : #{@pos[i + 1]} : #{@pos[i + 2]}\n"
  end

  def wrong_move
    puts 'Are you crazy! Try again.'
  end

  def ask_choice(player)
    puts "#{player}, make a decision. Choose a number from 1-9"
  end

  public

  def has_token?(i)
    CHOICES.include?(@pos[i - 1])
  end
end

grid = Grid.new