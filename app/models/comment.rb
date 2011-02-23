class Comment < ActiveRecord::Base
  attr_accessible :post_id, :user_id, :title, :body
  
  belongs_to :post
end
