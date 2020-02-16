require 'nokogiri'
require 'pp'
require 'open-uri'
require 'uri'
require "net/http"

class TweetController < ApplicationController

  before_action :set_tweet, only: [:show, :edit, :update, :destroy, :confirm]

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

    # @textを使ってTweetを作成
    @tweet = Tweet.new(content: @text)

    # idとして採番予定の数字を作成（現在作成しているidの次、存在しない場合は1を採番）
    if Tweet.last.present?
      next_id = Tweet.last.id + 1
    else
      next_id = 1
    end
    # 画像の生成メソッド呼び出し（画像のファイル名にidを使うため、引数として渡す）
    make_picture(next_id)
    if @tweet.save
      # 確認画面へリダイレクト
      redirect_to confirm_path(@tweet)
    else
      render :new
    end

    # query = URI.encode(@text + " " + "#Glitter")
    # @search_url = query
    # redirect_to("https://twitter.com/intent/tweet?text=#{@search_url}")
  end

  # confirmアクションを追加
  def confirm
  end

  private
    def working_url?(url_str)
      return open(@url).status.last == "OK"
    rescue
      false
    end

    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    def make_picture(id)
      sentense = ""
      # 改行を消去
      content = @tweet.content.gsub(/\r\n|\r|\n/," ")
      # contentの文字数に応じて条件分岐
      if content.length <= 28 then
        # 28文字以下の場合は7文字毎に改行
        n = (content.length / 7).floor + 1
        n.times do |i|
          s_num = i * 7
          f_num = s_num + 6
          range =  Range.new(s_num,f_num)
          sentense += content.slice(range)
          sentense += "\n" if n != i+1
        end
        # 文字サイズの指定
        pointsize = 90
      elsif content.length <= 50 then
        n = (content.length / 10).floor + 1
        n.times do |i|
          s_num = i * 10
          f_num = s_num + 9
          range =  Range.new(s_num,f_num)
          sentense += content.slice(range)
          sentense += "\n" if n != i+1
        end
        pointsize = 60
      else
        n = (content.length / 15).floor + 1
        n.times do |i|
          s_num = i * 15
          f_num = s_num + 14
          range =  Range.new(s_num,f_num)
          sentense += content.slice(range)
          sentense += "\n" if n != i+1
        end
        pointsize = 45
      end
      # 文字色の指定
      color = "white"
      # 文字を入れる場所の調整（0,0を変えると文字の位置が変わります）
      draw = "text 0,0 '#{sentense}'"
      # フォントの指定
      font = ".fonts/GenEiGothicN-black.jpgU-KL.otf"
      # ↑これらの項目も文字サイズのように背景画像や文字数によって変えることができます
      # 選択された背景画像の設定
      base = "app/assets/images/black.jpg"
      # minimagickを使って選択した画像を開き、作成した文字を指定した条件通りに挿入している
      image = MiniMagick::Image.open(base)
      image.combine_options do |i|
        i.font font
        i.fill color
        i.gravity 'center'
        i.pointsize pointsize
        i.draw draw
      end
      # 保存先のストレージの指定。Amazon S3を指定する。
      storage = Fog::Storage.new(
        provider: 'AWS',
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: 'ap-northeast-1'
      )
      # 開発環境or本番環境でS3のバケット（フォルダのようなもの）を分ける
      case Rails.env
        when 'production'
          # バケットの指定・URLの設定
          bucket = storage.directories.get('バケット名')
          # 保存するディレクトリ、ファイル名の指定（ファイル名は投稿id.pngとしています）
          png_path = 'images/' + id.to_s + '.png'
          image_uri = image.path
          file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
          @tweet.picture = 'https://s3-ap-northeast-1.amazonaws.com/バケット名' + "/" + png_path
        when 'development'
          bucket = storage.directories.get('bootcamp-glitter')
          png_path = 'images/' + id.to_s + '.png'
          image_uri = image.path
          file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
          @tweet.image_url = 'https://s3-ap-northeast-1.amazonaws.com/bootcamp-glitter' + "/" + png_path
      end
    end
end
