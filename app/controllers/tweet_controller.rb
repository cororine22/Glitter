require 'nokogiri'
require 'pp'
require 'open-uri'
require 'uri'

class TweetController < ApplicationController
  def new
  end

  def create
    @url = params[:url]
    urlhtml = Nokogiri::HTML(open(@url))

    # issueのタイトルを取得しツイート内容に表示
    urlhtml.xpath("//h1[@class='gh-header-title f1 mr-0 flex-auto break-word']").each do |elements|
      @text = (elements.xpath('.//span').text).gsub(/\r\n|\r|\n|\s|\t/, "")
    end
    query = URI.encode(@text + " " + "#Glitter")
    @search_url = query

    redirect_to("https://twitter.com/intent/tweet?text=#{@search_url}")
  end
end
