module ApplicationHelper
    def get_twitter_card_info(tweet)
      twitter_card = {}
      twitter_card[:url] = tweet.repository_url
      twitter_card[:image] = tweet.image_url

      twitter_card[:title] = "タイトル"
      twitter_card[:card] = 'summary_large_image'
      twitter_card[:description] = '説明文'
      twitter_card
    end
  end
