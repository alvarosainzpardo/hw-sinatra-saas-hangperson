class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @word_with_guesses = '-' * word.size
    @guesses = ""
    @wrong_guesses = ""
    @check_win_or_lose = :play
    @bad_attempts = 0
  end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_reader :word_with_guesses
  attr_reader :check_win_or_lose

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(letter)
    raise ArgumentError, 'Argument is nil' if letter == nil
    raise ArgumentError, 'Argument is empty' if letter.empty?
    raise ArgumentError, 'Argument is not a letter' unless letter =~ /[a-zA-Z]/
    return false if @check_win_or_lose != :play
    return false if @guesses.downcase.include? letter.downcase
    return false if @wrong_guesses.downcase.include? letter.downcase
    if @word.downcase.include? letter.downcase
      indexes = []
      current_index = -1
      while current_index = @word.downcase.index(letter.downcase, current_index + 1)
        indexes << current_index
      end
      @guesses << letter
      indexes.each { |index| @word_with_guesses[index] = @word[index] }
      @check_win_or_lose = :win if @word_with_guesses.downcase == @word.downcase
      return true
    else
      @wrong_guesses << letter
      @bad_attempts += 1
      @check_win_or_lose = :lose if @bad_attempts == 7
      return false
    end
  end

end
