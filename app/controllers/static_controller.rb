class StaticController < ApplicationController
  def home
    redirect_to 'http://snowball.is'
  end
end
