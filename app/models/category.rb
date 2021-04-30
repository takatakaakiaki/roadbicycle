class Category < ActiveHash::Base
  self.data = [
    { id: 1, name: '---' },
    { id: 2, name: 'コース' },
    { id: 3, name: 'トレーニング' },
    { id: 4, name: '機材' },
    { id: 5, name: '道具' },
    { id: 6, name: '大会' },
    { id: 7, name: 'スプリント' },
    { id: 8, name: 'ヒルクライム' },
    { id: 9, name: '募集' },
    { id: 10, name: 'その他' },
  ]

  include ActiveHash::Associations
  has_many :posts
end