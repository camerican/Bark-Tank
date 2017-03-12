class BuildSchema < ActiveRecord::Migration
  def change
    ### User Table
    create_table :users do |t|
      t.string  :name_first
      t.string  :name_last
      t.string  :slack_name
      t.text    :photo
      t.string  :slack_id
      t.string  :slack_token
      t.decimal :funds_remaining, precision: 8, scale: 2
      t.integer :status
      t.integer :role
      t.timestamps
    end
    ### Project Table
    create_table :projects do |t|
      t.string     :name
      t.text       :description
      t.string     :short
      t.text       :logo
      t.string     :url
      t.string     :git
      t.integer    :order
      t.integer    :status
    end
    ### ProjectMember Table
    create_table :project_members do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :status
    end
    ### ProjectRating
    create_table :project_ratings do |t|
      t.integer :user_id
      t.integer :project_id
      t.text    :feedback
      t.decimal :allocation, precision: 8, scale: 2
      t.timestamps
    end
  end
end
