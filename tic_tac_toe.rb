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
  CHOICES = %w[x o].freeze

  def initialize
    @pos = (1..9).to_a
    @player = []
  end

  def play
    assign_players
    create_grid
    game
  end

  def game
    gameover = false
    moves = 0

    until gameover
      @player.each_with_index do |player, i|
        choice = get_choice(player)
        update(player, choice)
        moves += 1

        next unless check_win? || moves == 9

        display_finish_msg(i, moves)
        gameover = end_game
        break
      end
    end
  end

  private

  def create_grid
    i = 0
    lines = { out: "    :   :    \n", mid: "----:---:----\n", pos: line_pos(i) }
    layout = %i[out pos mid pos mid pos out]
    layout.each do |l|
      print lines[l]
      lines[:pos] = line_pos(i += 3) if l == :mid
    end
  end

  def line_pos(index)
    "  #{@pos[index]} : #{@pos[index + 1]} : #{@pos[index + 2]}\n"
  end

  def update(player, position)
    @pos[position.to_i - 1] = player.token
    create_grid
  end

  def assign_players
    token = ''
    x = 1

    2.times do
      print "Player #{x}, Enter your name: "
      name = gets.chomp

      if token == ''
        until CHOICES.include?(token)
          print 'Choose x or o: '
          token = gets.chomp
        end
      else
        token = token == 'x' ? 'o' : 'x'
      end

      @player << Player.new(name, token)
      x += 1
    end
  end

  def check_win?
    WIN.any? { |w| [@pos[w[0]], @pos[w[1]], @pos[w[2]]].uniq.size == 1 }
  end

  def wrong_move
    print 'Are you crazy! Try again: '
  end

  def win_msg(index)
    puts "#{@player[index].name} is the winner! Suck it #{@player[index - 1].name}!"
  end

  def tie_msg
    puts 'You tied :( Try harder next time. Very disappointed in you both.'
  end

  def display_finish_msg(index, moves)
    if check_win?
      win_msg(index)
    elsif moves == 9
      tie_msg
    end
  end

  def end_game
    puts 'GAMEOVER'
    true
  end

  def correct_choice?(choice)
    choice.to_i.between?(1, 9) && !CHOICES.include?(@pos[choice - 1])
  end

  def get_choice(player)
    choice = ''
    print "#{player.name}, make a decision. Choose an empty space: "
    until correct_choice?(choice)
      choice = gets.chomp.to_i
      unless correct_choice?(choice)
        create_grid
        wrong_move
      end
    end
    choice
  end

  def token?(index)
    CHOICES.include?(@pos[index - 1])
  end
end

grid = Grid.new
grid.play
