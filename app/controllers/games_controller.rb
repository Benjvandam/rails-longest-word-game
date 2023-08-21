require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    for i in (0..9) do
      @letters[i] = ("a".."z").to_a.sample
    end
    unless session[:score]
      session[:score] = 0
    end
  end

  def score
    @answer = params[:answer]
    letters = []
    params[:letters].each_char do |char|
      letters << char
    end
    @answer.each_char do |letter|
      if letters.include?(letter)
        letters.delete(letter)
      else
        return @result = "Sorry but #{@answer} cannot be built out of #{letters}"
      end
    end

    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    serialized = URI.open(url).read
    word_exists = JSON.parse(serialized)["found"]

    if word_exists
      session[:score] = session[:score].to_i + 1
      @result = "Congratulations! #{@answer} is a valid English word"
    else
      @result = "Sorry but #{@answer} does not seem to be a valid English word"
    end

  end
end
