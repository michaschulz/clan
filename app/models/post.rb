class Post < ActiveRecord::Base
  attr_accessible :channel_id, :user_id, :title, :body
  
  has_many :comments
end
