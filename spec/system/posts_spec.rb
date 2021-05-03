require 'rails_helper'

def basic_pass
  username = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "記事の投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post_title = Faker::Lorem.sentence
    @post_text = Faker::Lorem.sentence
    @post_category = Faker::Lorem.sentence
    sleep(1)
  end

  context '記事の投稿ができる' do
    it 'ログインしたユーザーは記事を投稿できる' do
      # Basic認証
      basic_pass

      # ログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      find('input[name="commit"]').click

      # 新規投稿へのリンクがあることを確認する
      expect(page).to have_content("投稿する")

      # 投稿するボタンを押す
      click_link '投稿する'

      # 新規投稿ページに遷移したことを確認する
      expect(current_path).to eq(new_post_path)

      # 投稿する記事の内容を入力する
      attach_file 'post[image]', "app/assets/images/mainback.png"
      fill_in 'post[title]', with: @post_title
      fill_in 'post[text]', with: @post_text
      select '機材', from: 'post-category'

      # 投稿ボタンを押すとPostモデルのカウントが1増える
      expect{
        find('input[name="commit"]').click
      }.to change{ Post.count }.by(1)
      
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path) 

      # 投稿した記事があることを確認する
      expect(page).to have_content(@post_title)
    end

    it '画像がない場合でも他の内容を入力しているならば記事を投稿できる' do
      # ログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      find('input[name="commit"]').click

      # 新規投稿ページに移動する
      visit new_post_path

      # 投稿する記事の内容を入力する(画像以外)
      fill_in 'post[title]', with: @post_title
      fill_in 'post[text]', with: @post_text
      select '機材', from: 'post-category'

      # 投稿ボタンを押すとPostモデルのカウントが1増える
      expect{
        find('input[name="commit"]').click
      }.to change{ Post.count }.by(1)
      
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path) 

      # 投稿した記事があることを確認する
      expect(page).to have_content(@post_title)
    end
  end

  context '記事の投稿ができない' do
    it 'ログインしていないユーザーは記事の投稿ができない' do
      # トップページへ移動する
      visit root_path

      # ログインしていないユーザーは新規投稿ページに移動してもログインページに遷移する
      click_link '投稿する'
      expect(current_path).to eq(new_user_session_path)
    end

    it '正しい内容を入力しないと記事の投稿はできない' do
      # ログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      find('input[name="commit"]').click

      # 新規投稿ページに移動する
      visit new_post_path

      # 内容を入力しないで投稿をクリックすると新規投稿ページに戻される
      fill_in 'post[title]', with: ''
      fill_in 'post[text]', with: ''
      select '---', from: 'post-category'

      # 内容を入力しないで投稿をクリックしてもPostモデルのカウントは増えない
      expect{
        find('input[name="commit"]').click
      }.to change{ Post.count }.by(0)
    end
  end
end
