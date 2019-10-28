require 'json'
require 'open-uri'
require 'time'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a[rand(25)] }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    @result = result(@letters, @word)
  end

  def letters_used_once(letters, word)
    x = true

    word.upcase.chars.each do |char|
      if letters.include?(char)
        letters.delete_at(letters.index(char))
      else
        x = false
        break
      end
    end

    x
  end

  def result(letters, word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_dico = JSON.parse(open(url).read)
    final_result = { score: 0, message: 'Not in the grid!' }

    if word_dico['found'] && letters_used_once(letters, word)
      final_result[:score] = word_dico['length']
      final_result[:message] = 'Well done'
    elsif !word_dico['found'] && letters_used_once(letters, word)
      final_result[:message] = 'Not an English word!'
    end

    final_result
  end
end
