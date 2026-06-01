class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validates :user_alias, :first_name, :last_name, :email, presence: true
  # validates :user_alias, uniqueness: true, length: { minimum: 5 }
end
