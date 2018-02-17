class Group < ApplicationRecord
  belongs_to :user
  has_many :posts
  #以下為多對多的設定
  has_many :group_user_relationships
  has_many :members, through: :group_user_relationships, source: :user
  validates :title, presence: true

end
