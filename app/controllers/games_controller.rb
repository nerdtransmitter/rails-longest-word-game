require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    source = ('A'..'Z').to_a
    @letters = 9.times.map { source.sample }
    @start_time = Time.now.utc
    if session[:score].nil?
      session[:score] = 0
    end
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase.chars
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    response = JSON.parse(URI.open(url).read)

    @end_time = Time.now.utc
    @start_time = params[:start_time].to_datetime
    @time = @end_time - @start_time

    if response['found']
      if @word.all? { |letter| @word.count(letter) <= @letters.count(letter) }
        @score = (params[:word].length - @time / 60)
        session[:score] += @score
        @result = 'wins'
      else
        @score = 0
        @result = 'unbuildable'
      end
    else
      @score = 0
      @result = 'invalid'
    end
  end
end
