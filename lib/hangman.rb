require 'pry-byebug'
require 'yaml'

# holds dictionary.txt and fetches a word
class Dictionary
  attr_reader :word

  def initialize
    dictionary = File.readlines('dictionary.txt').each(&:chomp!)
    @word = ''
    @word = dictionary[(rand * 9895).floor] until @word.length.between?(5, 12)
  end
end

# orchestrating the game
class Game
  def initialize
    dictionary = Dictionary.new
    @word = dictionary.word
    @hidden_word = ''.rjust(2 * @word.length, '_ ')
    @letters_tried = ''
    @turn = 0
  end

  def greetings
    %(
      --------------------Welcome to HANGMAN--------------------
      The rules are classic and simple: guess a word 5 to 12 cha-
      racters long before your turns are over. Each turn you get
      to type in a lettter. If the letter is in the word, you'll
      see this letter appear in the word.
    )
  end

  def display_turns
    @turn += 1
    puts "#{12 - @turn} turns left"
    puts @hidden_word
    puts "Tried letters: #{@letters_tried}"
  end

  def input_guess
    gets.chomp.downcase.gsub(/\s+/, '')
  end

  def guess
    puts 'Input your letter below: '
    guess = input_guess
    until guess.length == 1 &&
          guess.ord.between?(97, 122) &&
          !@letters_tried.split(' ').include?(guess.upcase)
      puts 'Invalid letter. Ensure you enter !one! !english! letter that you\'ve !not used!: '
      guess = input_guess
    end
    check(guess)
  end

  def check(guess)
    not_included = true
    @word.split('').each_with_index do |letter, index|
      if letter == guess
        @hidden_word[index * 2] = letter
        not_included = false
      end
    end
    @letters_tried << ("#{guess.upcase} ")
  end

  def won
    !@hidden_word.include?('_')
  end

  def save
    puts 'Would you like to save the game? Y or N: '
    answer = gets.chomp.upcase
    until answer.include?('Y') || answer.include?('N')
      puts 'Error: please enter Y or N: '
      answer = gets.chomp.upcase
    end
    if answer == 'Y'
      Dir.mkdir('saves') unless Dir.exist?('saves')
      to_yaml
    end
  end

  def to_yaml
    save_string = YAML.dump({
                              turn: @turn,
                              hidden_word: @hidden_word,
                              word: @word,
                              letters_tried: @letters_tried
    })
    File.open('saves/save_file.yaml', 'w') { |f| f.write(save_string)}
    puts '////////////Game Saved////////////'
  end

  def from_yaml
    save = YAML.load_file('saves/save_file.yaml')
    @turn = save[:turn] - 1
    @hidden_word = save[:hidden_word]
    @word = save[:word]
    @letters_tried = save[:letters_tried]
    puts '////////////Game Loaded////////////'
  end

  def load?
    puts 'Would you like to start from the last save? Y or N: '
    answer = gets.chomp.upcase
    until answer.include?('Y') || answer.include?('N')
      puts 'Error: please enter Y or N: '
      answer = gets.chomp.upcase
    end
    from_yaml if answer == 'Y'
  end

  def play
    puts greetings
    load?
    until @turn == 12
      display_turns
      save unless @turn == 1
      guess
      break if won
    end
    puts won ? 'Congratulations! You have won the game.' : "Game over! The word was #{@word}"
  end
end

certain_game = Game.new
certain_game.play
