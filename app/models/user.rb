class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :alias, :first_name, :last_name, :email, presence: true
  validates :alias, uniqueness: true, length: { minimum: 5 }

  has_many :subscriptions, dependent: :destroy
  has_many :insights, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"

  def initials
    "#{first_name.first.upcase}#{last_name.first.upcase}"
  end
end
