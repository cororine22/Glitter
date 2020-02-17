class AddRepositoryUrl < ActiveRecord::Migration[6.0]
  def up
    add_column :tweets, :repository_url, :string
  end

  def down
    remove_column :tweets, :repository_url, :string
  end
end
