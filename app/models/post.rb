class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates :content, presence: true
  #以下為多對多的設定
  has_many :group_user_relationships
  has_many :members, through: :group_user_relationships, source: :user

  scope :recent, -> {order("created_at DESC")}
end
