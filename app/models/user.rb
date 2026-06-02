class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :alias, :first_name, :last_name, :email, presence: true
  validates :alias, uniqueness: true, length: { minimum: 5 }

  has_many :subscriptions, dependent: :destroy
  has_many :insights, dependent: :destroy
end
