class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :user_diaries, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :spending_plans, dependent: :destroy
  has_many :allow_sharings, dependent: :destroy

  validates :name, presence: true,
                   length: {maximum: Settings.user.name.max_length}
  enum role: {user: 0, admin: 1}

  before_save :downcase_email

  class << self
    def User.digest string
      cost = BCrypt::Engine.cost
      cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
      BCrypt::Password.create string, cost: cost
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
