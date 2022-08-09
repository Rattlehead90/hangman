require 'pry-byebug'

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
    puts "#{12 - @turn} turns left}"
    puts @hidden_word
    puts "Tried letters: #{@letters_tried}"
  end

  def guess
    puts 'Input your letter below: '
    guess = gets.chomp.downcase
    until guess.length == 1 && guess.ord.between?(97, 122)
      puts 'Invalid letter. Ensure you enter !one! !english! letter: '
      guess = gets.chomp.downcase
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
    if not_included
      @letters_tried << (guess.upcase + ' ')
    end
  end

  def play
    puts greetings
    until @turn == 12
      display_turns
      guess
    end
  end
end

certain_game = Game.new
certain_game.play
