class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :groups
  has_many :posts
  #以下為多對多的設定
  has_many :group_user_relationships
  has_many :participated_groups, through: :group_user_relationships, source: :group

  #判斷成員是否為group中的一員
  def is_member_of?(group)
    participated_groups.include?(group)
  end
  #加入群組
  def join!(group)
    participated_groups << group
  end
  #退出群組
  def quit!(group)
    participated_groups.delete(group)
  end
end
