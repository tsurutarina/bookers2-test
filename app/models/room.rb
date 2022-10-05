class Room < ApplicationRecord
  has_many :user_rooms
  # 一つのルームにいるユーザー数は二人のためhas_manyになる
  has_many :chats
end
