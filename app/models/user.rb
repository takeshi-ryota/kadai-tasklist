class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :tasks
  has_many :likes
  has_many :liketask,through: :likes,source: :task
  has_many :reverses_of_likes,class_name: 'Like',foreign_key:'task_id'
  has_many :likeuser,through: :reverses_of_likes,source: :user
  
  def like(like_task)
    self.likes.find_or_create_by(task_id: like_task.id)
  end
  
  def dislike(like_task)
    task = self.likes.find_by(task_id: like_task.id)
    task.destroy if like
  end
  
  def like?(like_task)
    self.liketask.include?(like_task)
  end
end
