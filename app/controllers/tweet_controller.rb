class TweetController < ApplicationController
  def new
  end

  def create
    @url = params[:url]
    redirect_to("https://twitter.com/intent/tweet?text=#{@url}")
  end
end
