class Post < ActiveRecord::Base
  has_many :comments

  attr_accessible :content, :name, :title

  validates :name, :presence => true
  validates :content, :presence => true, :length => { :minimum => 10 }
end
