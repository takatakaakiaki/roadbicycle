# テーブル設計

## users テーブル

| Column             | Type   | Options                  |
| ------------------ | ------ | ------------------------ |
| username           | string | null: false              |
| email              | string | null: false, unique:true |
| encrypted_password | string | null: false              |
| name               | string | null: false              |
| birthday           | date   | null: false              |

### Association

- has_many :posts
- has_many :messages
- has_one :personal

## posts テーブル

| Column        | Type       | Options           |
| ------------- | ---------- | ----------------- |
| title         | string     | null: false       |
| text          | text       | null: false       |
| category_id   | integer    | null: false       |
| user          | references | foreign_key: true |

### Association

- belongs_to :user
- has_many :messages

## messages テーブル

| Column  | Type       | Options           |
| ------- | ---------- | ----------------- |
| comment | text       |                   |
| user    | references | foreign_key: true |
| post    | references | foreign_key: true |


### Association

- belongs_to :user
- belongs_to :post


## personals テーブル

| Column        | Type       | Options           |
| ------------- | ---------- | ----------------- |
| course_plan   |            |                   |
| course        |            |                   |
| training_plan |            |                   |
| training      |            |                   |
| mileage_plan  |            |                   |
| mileage       |            |                   |
| user          | references | foreign_key: true |

### Association

- belongs_to :user