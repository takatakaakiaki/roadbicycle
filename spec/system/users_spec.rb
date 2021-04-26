require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができる' do
    it '正しい情報を入力するとユーザーの新規登録ができる' do
      # トップページへ移動
      visit root_path
        
      # トップページにユーザー登録へ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')

      # 新規登録をクリック
      find_link('新規登録').click
      
      # ユーザー登録ページへ遷移したことを確認する
      expect(current_path).to eq(new_user_registration_path)

      # ユーザー情報を入力する
      fill_in 'user[username]', with: @user.username
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      fill_in 'user[password_confirmation]', with: @user.password_confirmation
      fill_in 'user[name]', with: '柿九毛子'
      select '2000', from: 'user_birthday_1i'
      select '2', from: 'user_birthday_2i'
      select '2', from: 'user_birthday_3i'

      # 登録するをクリックするとユーザーモデルのカウントが1増える
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(1)

      # トップページへ遷移したことを確認
      expect(current_path).to eq(root_path)

      # ヘッダーにユーザー名とログアウトが表示されていることを確認
      expect(page).to have_content(@user.username)
      expect(page).to have_content('ログアウト')
      
      # ヘッダーにログインと新規登録が表示されていないことを確認
      expect(page).to have_no_content('ログイン')
      expect(page).to have_no_content('新規登録')
    end
  end

  context 'ユーザー新規登録ができない' do
    it '誤った情報を入力するとユーザーの新規登録ができず、ユーザー登録ページに戻ってくる' do
      # ユーザー登録ページに移動する
      visit new_user_registration_path

      # ユーザー情報に誤った情報を入力する
      fill_in 'user[username]', with: ''
      fill_in 'user[email]', with: '1111aaaa'
      fill_in 'user[password]', with: 'abcd123'
      fill_in 'user[password_confirmation]',with: 'aabb4444'
      fill_in 'user[name]', with: ''
      select '--', from: 'user_birthday_1i'
      select '--', from: 'user_birthday_2i'
      select '--', from: 'user_birthday_3i'

      # 登録するをクリックしてもユーザーモデルのカウントは増えない
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)

      # ユーザー登録ページへ戻ってくることを確認 
      expect(current_path).to eq("/users")
    end

    it '何も入力しなけるばユーザーの新規登録ができず、ユーザー登録ページに戻ってくる' do
      # ユーザー登録ページに移動する
      visit new_user_registration_path

      # ユーザー情報に何も入力しない
      fill_in 'user[username]', with: ''
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]',with: ''
      fill_in 'user[name]', with: ''
      select '--', from: 'user_birthday_1i'
      select '--', from: 'user_birthday_2i'
      select '--', from: 'user_birthday_3i'

      # 登録するをクリックしてもユーザーモデルのカウントは増えない
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)

      # ユーザー登録ページへ戻ってくることを確認 
      expect(current_path).to eq("/users")
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context'ログインができる'do
    it '登録されているユーザーの情報を入力するとログインができる' do
      # トップページへ移動する
      visit root_path

      # トップページにログインへ遷移できるボタンがあることを確認
      expect(page).to have_content('ログイン')

      # ログインのボタンをクリックするとログインページへ移動できる
      find_link('ログイン').click

      # ログインページへ遷移できたことを確認
      expect(current_path).to eq(new_user_session_path)

      # ユーザー情報を入力する
      fill_in 'user[email]', with: @user.email 
      fill_in 'user[password]', with: @user.password 

      # ログインを押す      
      find('input[name="commit"]').click

      # トップページに遷移できたことを確認
      expect(current_path).to eq(root_path)

      # ヘッダーにユーザー名とログアウトが表示されていることを確認
      expect(page).to have_content(@user.username)
      expect(page).to have_content('ログアウト')
      
      # ヘッダーにログインと新規登録が表示されていないことを確認
      expect(page).to have_no_content('ログイン')
      expect(page).to have_no_content('新規登録')
    end

    it '誤った情報を入力するとログインはできない' do
      # ログインページへ移動する
      visit new_user_session_path

      # 誤った情報を入力する
      fill_in 'user[email]', with: 'aaa@aaa' 
      fill_in 'user[password]', with: '1234abcd'       

      # ログインを押す
      find('input[name="commit"]').click

      # ログインページへ戻されていることを確認する
      expect(current_path).to eq(new_user_session_path)
    end

    it '何も入力しなければログインはできない' do
      # ログインページへ移動する
      visit new_user_session_path

      # 何も入力しない
      fill_in 'user[email]', with: '' 
      fill_in 'user[password]', with: ''       

      # ログインを押す
      find('input[name="commit"]').click

      # ログインページへ戻されていることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe 'ログアウト', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context'ログアウトができる'do
    it 'ヘッダーにあるログアウトをクリックするとログアウトできる' do
      # トップページへ移動する
      visit new_user_session_path

      # ユーザー情報を入力する
      fill_in 'user[email]', with: @user.email 
      fill_in 'user[password]', with: @user.password 

      # ログインを押す
      find('input[name="commit"]').click

      # トップページに遷移できたことを確認
      expect(current_path).to eq(root_path)

      # ヘッダーにユーザー名とログアウトが表示されていることを確認
      expect(page).to have_content(@user.username)
      expect(page).to have_content('ログアウト')

      # ログアウトを押すとログアウトができる
      find_link('ログアウト').click

      # ヘッダーにユーザー名とログアウトが表示されていないことを確認
      expect(page).to have_no_content(@user.username)
      expect(page).to have_no_content('ログアウト')
    end
  end
end