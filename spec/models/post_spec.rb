require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @post = FactoryBot.build(:post)
  end

  describe '記事の投稿' do
    context '記事の投稿ができる' do
      it '画像、記事のタイトル、記事の内容、記事の種類を入力すると投稿できる' do
        expect(@post).to be_valid
      end

      it '画像はなくても投稿できる' do
        @post.image = ''
        @post.title = 'テスト'
        @post.text = 'テスト'
        @post.category_id = 4
        expect(@post).to be_valid
      end
    end

    context '記事の投稿ができない' do
      it '記事のタイトルが空だと記事の投稿ができない' do
        @post.title = ''
        @post.valid?
        expect(@post.errors.full_messages).to include("タイトルを入力してください")
      end

      it '記事の内容が空だと記事の投稿ができない' do
        @post.text = ''
        @post.valid?
        expect(@post.errors.full_messages).to include("内容を入力してください")
      end

      it '記事の種類が---だと記事の投稿ができない' do
        @post.category_id = 1
        @post.valid?
        expect(@post.errors.full_messages).to include("記事の種類を選択してください")
      end
    end
  end
end
