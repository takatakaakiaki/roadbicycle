require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context 'ユーザー新規登録ができる' do
      it 'ユーザー名、メールアドレス、パスワード、パスワード再入力、お名前、生年月日が正しく入力できていると登録できる' do
        expect(@user).to be_valid
      end
    end
        
    context 'ユーザー新規登録ができない' do
      it 'ユーザー名が空だと登録できない' do
        @user.username = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("ユーザー名を入力してください")
      end

      it 'メールアドレスが空だと登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Eメールを入力してください")
      end

      it 'メールアドレスに@がないと登録できない' do
        @user.email = 'aaabbb'
        @user.valid?
        expect(@user.errors.full_messages).to include("Eメールは不正な値です")
      end      

      it '既に登録されているメールアドレスを入力した場合は登録できない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Eメールはすでに存在します")
      end      

      it 'パスワードが空だと登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードを入力してください")
      end

      it 'パスワードは数字だけでは登録できない' do
        @user.password = '123456789'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードには英字と数字の両方を含めて設定してください")        
      end

      it 'パスワードは英字だけでは登録できない' do
        @user.password = 'aaaabbbbcc'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードには英字と数字の両方を含めて設定してください")                
      end

      it 'パスワードに全角文字では登録できない' do
        @user.password = '１２３４AABBCC'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードには英字と数字の両方を含めて設定してください")                        
      end

      it 'パスワードは7文字以下では登録できない' do
        @user.password = '1234abc'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードは8文字以上で入力してください")                        
      end

      it 'パスワード（確認）は空だと登録できない' do
        @user.password_confirmation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
      end

      it 'パスワード（確認）はパスワードと一致していないと登録できない' do
        @user.password = '3333aaaa'
        @user.password_confirmation = '2222gggg'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
      end

      it 'お名前は空欄では登録できない' do
        @user.name = '' 
        @user.valid?
        expect(@user.errors.full_messages).to include("名前を入力してください")       
      end

      it '生年月日は空欄では登録できない' do
        @user.birthday = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("生年月日を入力してください")
      end
    end    
  end
end
