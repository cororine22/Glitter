require 'nokogiri'
require 'pp'
require 'open-uri'
require 'uri'
require "net/http"

class TweetController < ApplicationController
  def new
  end

  def create
    @url = "https://github.com/" + params[:url]

    # TODO: ユーザにダイアログ表示
    return until URI.regexp.match(@url) && working_url?(@url)

    urlhtml = Nokogiri::HTML(open(@url))

    # issueのタイトルを取得しツイート内容に表示
    urlhtml.xpath("//h1[@class='gh-header-title f1 mr-0 flex-auto break-word']").each do |elements|
      @text = (elements.xpath('.//span').text).gsub(/\r\n|\r|\n|\s|\t/, "")
    end

    # TODO: ユーザにダイアログ表示
    return if @text.nil?

    query = URI.encode(@text + " " + "#Glitter")
    @search_url = query
    redirect_to("https://twitter.com/intent/tweet?text=#{@search_url}")
  end

  def working_url?(url_str)
    return open(@url).status.last == "OK"
  rescue
    false
  end
end
