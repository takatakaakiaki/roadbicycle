class Post < ApplicationRecord




  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :Category

  validates :category_id, numericality: { other_than: 1 }

end
