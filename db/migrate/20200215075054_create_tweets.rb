class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets do |t|
      t.string :user
      t.text :content
      t.string :image_url
      t.datetime :posted_at

      t.timestamps
    end
  end
end
