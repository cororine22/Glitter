module ApplicationHelper
    def get_twitter_card_info(tweet)
      twitter_card = {}
      if tweet.present?
        if tweet.id.present?
          twitter_card[:url] = "https://evening-shore-25523.herokuapp.com/tweet/#{tweet.id}"
          twitter_card[:image] = "https://s3-ap-northeast-1.amazonaws.com/bootcamp-glitter/images/#{tweet.id}.png"
        else
          twitter_card[:url] = 'https://evening-shore-25523.herokuapp.com/'
          twitter_card[:image] = "https://raw.githubusercontent.com/ysk1180/bigtutorial/master/app/assets/images/top.png"
        end
      else
        twitter_card[:url] = 'https://evening-shore-25523.herokuapp.com/'
        twitter_card[:image] = "https://raw.githubusercontent.com/ysk1180/bigtutorial/master/app/assets/images/top.png"
      end
      twitter_card[:title] = "タイトル"
      twitter_card[:card] = 'summary_large_image'
      twitter_card[:description] = '説明文'
      twitter_card
    end
  end
