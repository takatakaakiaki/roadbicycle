class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  with_options presence: true do
    validates :title
    validates :text
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :Category

  validates :category_id, numericality: { other_than: 1 ,message: 'を選択してください' }

end
